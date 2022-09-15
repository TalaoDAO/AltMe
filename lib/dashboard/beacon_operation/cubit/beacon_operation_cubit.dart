import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/tezart.dart';

part 'beacon_operation_cubit.g.dart';
part 'beacon_operation_state.dart';

class BeaconOperationCubit extends Cubit<BeaconOperationState> {
  BeaconOperationCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
  }) : super(BeaconOperationState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;

  final log = getLogger('BeaconOperationCubit');

  void setNetworkFee({required NetworkFeeModel networkFee}) {
    emit(state.copyWith(networkFee: networkFee));
  }

  Future<void> send() async {
    try {
      log.i('started sending');
      emit(state.loading());

      final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

      final CryptoAccountData? currentAccount =
          walletCubit.state.cryptoAccount.data.firstWhereOrNull(
        (element) =>
            element.walletAddress == beaconRequest.request!.sourceAddress!,
      );

      if (currentAccount == null) {
        // TODO(bibash): account data not available error message may be
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      final sourceKeystore = Keystore.fromSecretKey(currentAccount.secretKey);

      final client = TezartClient(beaconRequest.request!.network!.rpcUrl!);

      final amount =
          int.parse(beaconRequest.request!.operationDetails!.first.amount!);

      final customFee = int.parse(
        state.networkFee.fee
            .toStringAsFixed(6)
            .replaceAll('.', '')
            .replaceAll(',', ''),
      );

      final operationsList = await client.transferOperation(
        source: sourceKeystore,
        destination:
            beaconRequest.request!.operationDetails!.first.destination!,
        amount: amount,
        customFee: customFee,
      );
      log.i(
        'before execute: withdrawal from secretKey: ${sourceKeystore.secretKey}'
        ' , publicKey: ${sourceKeystore.publicKey} '
        'amount: $amount '
        'networkFee: $customFee '
        'address: ${sourceKeystore.address} =>To address: '
        '${beaconRequest.request!.operationDetails!.first.destination!}',
      );

      await operationsList.executeAndMonitor();
      log.i('after withdrawal execute');
      final String transactionHash = operationsList.result.id!;

      final Map response = await beacon.operationResponse(
        id: beaconCubit.state.beaconRequest!.request!.id!,
        transactionHash: transactionHash,
      );

      final bool success = json.decode(response['success'].toString()) as bool;

      if (success) {
        log.i('operation success');
        emit(
          state.copyWith(
            appStatus: AppStatus.success,
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_OPERATION_COMPLETED,
            ),
          ),
        );
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_OPERATION_FAILED,
        );
      }
    } catch (e) {
      log.e('operation failure , e: $e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  void rejectOperation() {
    log.i('beacon connection rejected');
    beacon.operationResponse(
      id: beaconCubit.state.beaconRequest!.request!.id!,
      transactionHash: null,
    );
    emit(state.copyWith(appStatus: AppStatus.success));
  }
}
