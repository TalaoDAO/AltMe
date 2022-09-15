import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_operation_cubit.g.dart';
part 'beacon_operation_state.dart';

class BeaconOperationCubit extends Cubit<BeaconOperationState> {
  BeaconOperationCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
  }) : super(const BeaconOperationState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;

  final log = getLogger('BeaconOperationCubit');

  Future<void> send() async {
    try {
      log.i('started sending');
      emit(state.loading());

      final CryptoAccountData? currentAccount =
          walletCubit.state.cryptoAccount.data.firstWhereOrNull(
        (element) =>
            element.walletAddress ==
            beaconCubit.state.beaconRequest!.request!.sourceAddress!,
      );

      if (currentAccount == null) {
        // TODO(bibash): account data not available error message may be
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      final KeyStoreModel sourceKeystore =
          getKeysFromSecretKey(secretKey: currentAccount.secretKey);

      // final client = TezartClient(manageNetworkCubit.state.network.rpcNodeUrl);

      // final amount = int.parse(
      //   tokenAmount.toStringAsFixed(6).replaceAll(',', '').replaceAll('.', ''),
      // );
      // final customFee = int.parse(
      //   state.networkFee.fee
      //       .toStringAsFixed(6)
      //       .replaceAll('.', '')
      //       .replaceAll(',', ''),
      // );

      // final operationsList = await client.transferOperation(
      //   source: sourceKeystore,
      //   destination: state.withdrawalAddress,
      //   amount: amount,
      //   customFee: customFee,
      // );
      // logger.i(
      //   'before execute: withdrawal from secretKey: ${sourceKeystore.secretKey}'
      //   ' , publicKey: ${sourceKeystore.publicKey} '
      //   'amount: $amount '
      //   'networkFee: $customFee '
      //   'address: ${sourceKeystore.address} =>To address: '
      //   '${state.withdrawalAddress}',
      // );
      // // ignore: unawaited_futures
      // operationsList.executeAndMonitor();
      // logger.i('after withdrawal execute');
      // emit(state.success());
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE,
            ),
          ),
        );
      }
    }
  }

  void rejectConnection() {
    log.i('beacon connection rejected');
    beacon.permissionResponse(
      id: beaconCubit.state.beaconRequest!.request!.id!,
      publicKey: null,
      address: null,
    );
    emit(state.copyWith(appStatus: AppStatus.success));
  }
}
