import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:tezart/tezart.dart';

part 'beacon_operation_cubit.g.dart';
part 'beacon_operation_state.dart';

class BeaconOperationCubit extends Cubit<BeaconOperationState> {
  BeaconOperationCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
    required this.dioClient,
    required this.keyGenerator,
    required this.nftCubit,
  }) : super(const BeaconOperationState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final DioClient dioClient;
  final KeyGenerator keyGenerator;
  final NftCubit nftCubit;

  final log = getLogger('BeaconOperationCubit');

  Future<void> initial() async {
    await getFees();
  }

  Future<void> getXtzPrice() async {
    try {
      log.i('fetching xtz price');
      final response =
          await dioClient.get(Urls.xtzPrice) as Map<String, dynamic>;
      final XtzData xtzData = XtzData.fromJson(response);
      log.i('response - ${xtzData.toJson()}');
      emit(state.copyWith(xtzUSDRate: xtzData.price));
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> getFees() async {
    try {
      emit(state.loading());
      log.i('estimateOperationFee');

      final operationList = await getOperationList();
      await operationList.estimate();
      log.i('after operationList.estimate()');
      final fee = operationList.operations
          .map((Operation e) => e.totalFee)
          .reduce((int value, int element) => value + element);

      emit(state.copyWith(status: AppStatus.idle, totalFee: fee));
    } catch (e) {
      log.e('cost estimation failure , e: $e');
      if (e is MessageHandler) {
        emit(
          state.copyWith(
            status: AppStatus.errorWhileFetching,
            messageHandler: e,
          ),
        );
      } else if (e is TezartNodeError) {
        final Map<String, String> json = e.metadata;
        if (json['reason'] == 'contract.balance_too_low') {
          emit(
            state.copyWith(
              status: AppStatus.errorWhileFetching,
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE,
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AppStatus.errorWhileFetching,
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: AppStatus.errorWhileFetching,
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  Future<void> sendOperataion() async {
    try {
      emit(state.loading());
      log.i('sendOperataion');

      final operationList = await getOperationList();
      await operationList.executeAndMonitor();
      log.i('after operationList.executeAndMonitor()');

      final transactionHash = operationList.result.id;

      final Map response = await beacon.operationResponse(
        id: beaconCubit.state.beaconRequest!.request!.id!,
        transactionHash: transactionHash,
      );

      final bool success = json.decode(response['success'].toString()) as bool;

      if (success) {
        log.i('operation success');
        emit(
          state.copyWith(
            status: AppStatus.success,
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_OPERATION_COMPLETED,
            ),
          ),
        );
        unawaited(nftCubit.onRefresh());
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_OPERATION_FAILED,
        );
      }
    } catch (e) {
      log.e('sendOperataion , e: $e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else if (e is TezartNodeError) {
        final Map<String, String> json = e.metadata;
        if (json['reason'] == 'contract.balance_too_low') {
          emit(
            state.error(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE,
              ),
            ),
          );
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
    emit(state.copyWith(status: AppStatus.success));
  }

  Future<OperationsList> getOperationList() async {
    try {
      log.i('getOperationList');

      final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

      final CryptoAccountData? currentAccount =
          walletCubit.state.cryptoAccount.data.firstWhereOrNull(
        (element) =>
            element.walletAddress == beaconRequest.request!.sourceAddress!,
      );

      if (currentAccount == null) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      /// check xtz balance
      //late String baseUrl;
      late String rpcNodeUrl;

      if (beaconRequest.request!.network!.type! == NetworkType.mainnet) {
        //baseUrl = TezosNetwork.mainNet().tzktUrl;
        rpcNodeUrl = TezosNetwork.mainNet().rpcNodeUrl;
      } else if (beaconRequest.request!.network!.type! ==
          NetworkType.ghostnet) {
        //baseUrl = TezosNetwork.ghostnet().tzktUrl;
        rpcNodeUrl = TezosNetwork.ghostnet().rpcNodeUrl;
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      final amount = int.parse(beaconRequest.operationDetails!.first.amount!);

      // TezartErro handles low balande
      // log.i('checking xtz');
      // final int balance = await dioClient.get(
      //   '$baseUrl/v1/accounts/${beaconRequest.request!.sourceAddress!}/balance',
      // ) as int;
      // log.i('total xtz - $balance');
      // final formattedBalance = int.parse(
      //   balance.toStringAsFixed(6).replaceAll('.', '').replaceAll(',', ''),
      // );

      // if ((amount + state.totalFee!) > formattedBalance) {
      //   throw ResponseMessage(
      //     ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE,
      //   );
      // }

      final client = TezartClient(rpcNodeUrl);
      final keystore =
          keyGenerator.getKeystore(secretKey: currentAccount.secretKey);

      final operationList =
          OperationsList(source: keystore, rpcInterface: client.rpcInterface);

      final List<Operation> operations = getOperation();
      for (final element in operations) {
        operationList.appendOperation(element);
      }

      final isReveal = await client.isKeyRevealed(keystore.address);
      if (!isReveal) {
        operationList.prependOperation(RevealOperation());
      }

      log.i(
        'secretKey: ${keystore.secretKey}'
        'publicKey: ${keystore.publicKey} '
        'amount: $amount '
        'networkFee: ${state.totalFee} '
        'address: ${keystore.address} =>To address: '
        '${beaconRequest.operationDetails!.first.destination!}',
      );

      return operationList;
    } catch (e) {
      if (e is MessageHandler) {
        rethrow;
      } else if (e is TezartNodeError) {
        log.e(e.metadata);
        rethrow;
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }
    }
  }

  List<Operation> getOperation() {
    final List<Operation> operations = [];

    final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

    for (final operationDetail in beaconRequest.operationDetails!) {
      final String? storageLimit = operationDetail.storageLimit;
      final String? gasLimit = operationDetail.gasLimit;
      final String? fee = operationDetail.fee;

      if (operationDetail.kind == Kinds.origination) {
        final String balance = operationDetail.amount ?? '0';
        final List<Map<String, dynamic>> code = operationDetail.code!;
        final dynamic storage = operationDetail.storage;

        final operation = OriginationOperation(
          balance: int.parse(balance),
          code: code,
          storage: storage,
          customFee: fee != null ? int.parse(fee) : null,
          customGasLimit: gasLimit != null ? int.parse(gasLimit) : null,
          customStorageLimit:
              storageLimit != null ? int.parse(storageLimit) : null,
        );
        operations.add(operation);
      } else {
        final String destination = operationDetail.destination ?? '';
        final String amount = operationDetail.amount ?? '0';
        final String? entrypoint = operationDetail.entrypoint;

        final dynamic parameters = operationDetail.parameters != null
            ? jsonDecode(jsonEncode(operationDetail.parameters))
            : null;

        final operation = TransactionOperation(
          amount: int.parse(amount),
          destination: destination,
          entrypoint: entrypoint,
          params: parameters,
          customFee: fee != null ? int.parse(fee) : null,
          customGasLimit: gasLimit != null ? int.parse(gasLimit) : null,
          customStorageLimit:
              storageLimit != null ? int.parse(storageLimit) : null,
        );

        operations.add(operation);
      }
    }

    log.i('operations - $operations');
    return operations;
  }
}
