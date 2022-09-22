import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/dashboard.dart';
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
  }) : super(const BeaconOperationState()) {
    initial();
  }

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final DioClient dioClient;
  final KeyGenerator keyGenerator;

  final log = getLogger('BeaconOperationCubit');

  void initial() {
    getXtzPrice();
    getFees();
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

      late String rpcNodeUrl;

      if (beaconRequest.request!.network!.type! == NetworkType.mainnet) {
        rpcNodeUrl = TezosNetwork.mainNet().rpcNodeUrl;
      } else if (beaconRequest.request!.network!.type! ==
          NetworkType.ghostnet) {
        rpcNodeUrl = TezosNetwork.ghostnet().rpcNodeUrl;
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      final client = TezartClient(rpcNodeUrl);

      final keystore =
          keyGenerator.getKeystore(secretKey: currentAccount.secretKey);

      final operationList =
          OperationsList(source: keystore, rpcInterface: client.rpcInterface);

      final List<Operation> operations =
          getOperation(beaconRequest: beaconRequest);

      for (final element in operations) {
        operationList.appendOperation(element);
      }

      final isReveal = await client.isKeyRevealed(keystore.address);
      if (!isReveal) {
        operationList.prependOperation(RevealOperation());
      }

      await operationList.estimate();

      final fee = operationList.operations
          .map((Operation e) => e.fee)
          .reduce((int value, int element) => value + element);

      emit(state.copyWith(status: AppStatus.idle, totalFee: fee));
    } catch (e) {
      log.e('cost estimation failure , e: $e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
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
      log.i('sendOperataion');

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

      final amount = int.parse(beaconRequest.operationDetails!.first.amount!);

      // check xtz balance
      late String baseUrl;
      late String rpcNodeUrl;

      if (beaconRequest.request!.network!.type! == NetworkType.mainnet) {
        baseUrl = TezosNetwork.mainNet().tzktUrl;
        rpcNodeUrl = TezosNetwork.mainNet().rpcNodeUrl;
      } else if (beaconRequest.request!.network!.type! ==
          NetworkType.ghostnet) {
        baseUrl = TezosNetwork.ghostnet().tzktUrl;
        rpcNodeUrl = TezosNetwork.ghostnet().rpcNodeUrl;
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      log.i('checking xtz');
      final int balance = await dioClient.get(
        '$baseUrl/v1/accounts/${beaconRequest.request!.sourceAddress!}/balance',
      ) as int;
      log.i('total xtz - $balance');
      final formattedBalance = int.parse(
        balance.toStringAsFixed(6).replaceAll('.', '').replaceAll(',', ''),
      );

      if ((amount + state.totalFee!) > formattedBalance) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE,
        );
      }

      final client = TezartClient(rpcNodeUrl);

      final keystore =
          keyGenerator.getKeystore(secretKey: currentAccount.secretKey);

      final operationList =
          OperationsList(source: keystore, rpcInterface: client.rpcInterface);

      final List<Operation> operations =
          getOperation(beaconRequest: beaconRequest);

      for (final element in operations) {
        operationList.appendOperation(element);
      }

      final isReveal = await client.isKeyRevealed(keystore.address);
      if (!isReveal) {
        operationList.prependOperation(RevealOperation());
      }

      log.i(
        'before execute: withdrawal from secretKey: ${keystore.secretKey}'
        ' , publicKey: ${keystore.publicKey} '
        'amount: $amount '
        'networkFee: ${state.totalFee} '
        'address: ${keystore.address} =>To address: '
        '${beaconRequest.operationDetails!.first.destination!}',
      );

      await operationList.executeAndMonitor();
      log.i('after withdrawal execute');

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
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_OPERATION_FAILED,
        );
      }
    } catch (e) {
      log.e('sendOperataion , e: $e');
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

  // Future<void> send() async {
  //   try {
  //     log.i('started sending');
  //     emit(state.loading());

  //     final BeaconRequest beaconRequest = beaconCubit.state.beaconRequest!;

  //     final CryptoAccountData? currentAccount =
  //         walletCubit.state.cryptoAccount.data.firstWhereOrNull(
  //       (element) =>
  //           element.walletAddress == beaconRequest.request!.sourceAddress!,
  //     );

  //     if (currentAccount == null) {
  //       // TODO(bibash): account data not available error message may be
  //       throw ResponseMessage(
  //         ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
  //       );
  //     }

  //     final sourceKeystore = Keystore.fromSecretKey(currentAccount.secretKey);

  //     final client = TezartClient(beaconRequest.request!.network!.rpcUrl!);

  //     final amount = int.parse(beaconRequest.operationDetails!.first.amount!);

  //     final customFee = int.parse(
  //       state.networkFee.fee
  //           .toStringAsFixed(6)
  //           .replaceAll('.', '')
  //           .replaceAll(',', ''),
  //     );

  //     // check xtz balance
  //     late String baseUrl;

  //     if (beaconRequest.request!.network!.type! == NetworkType.mainnet) {
  //       baseUrl = TezosNetwork.mainNet().tzktUrl;
  //     } else if (beaconRequest.request!.network!.type! ==
  //         NetworkType.ghostnet) {
  //       baseUrl = TezosNetwork.ghostnet().tzktUrl;
  //     } else {
  //       throw ResponseMessage(
  //         ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
  //       );
  //     }

  //     log.i('checking xtz');
  //     final int balance = await dioClient.get(
  //       '$baseUrl/v1/accounts/${beaconRequest.request!.sourceAddress!}/balance',
  //     ) as int;
  //     log.i('total xtz - $balance');
  //     final formattedBalance = int.parse(
  //       balance.toStringAsFixed(6).replaceAll('.', '').replaceAll(',', ''),
  //     );

  //     if ((amount + customFee) > formattedBalance) {
  //       throw ResponseMessage(
  //         ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE,
  //       );
  //     }

  //     // send xtz
  //     final operationsList = await client.transferOperation(
  //       source: sourceKeystore,
  //       destination: beaconRequest.operationDetails!.first.destination!,
  //       amount: amount,
  //       customFee: customFee,
  //     );
  //     log.i(
  //       'before execute: withdrawal from secretKey: ${sourceKeystore.secretKey}'
  //       ' , publicKey: ${sourceKeystore.publicKey} '
  //       'amount: $amount '
  //       'networkFee: $customFee '
  //       'address: ${sourceKeystore.address} =>To address: '
  //       '${beaconRequest.operationDetails!.first.destination!}',
  //     );

  //     await operationsList.executeAndMonitor();
  //     log.i('after withdrawal execute');
  //     final String transactionHash = operationsList.result.id!;

  //     final Map response = await beacon.operationResponse(
  //       id: beaconCubit.state.beaconRequest!.request!.id!,
  //       transactionHash: transactionHash,
  //     );

  //     final bool success = json.decode(response['success'].toString()) as bool;

  //     if (success) {
  //       log.i('operation success');
  //       emit(
  //         state.copyWith(
  //           appStatus: AppStatus.success,
  //           messageHandler: ResponseMessage(
  //             ResponseString.RESPONSE_STRING_OPERATION_COMPLETED,
  //           ),
  //         ),
  //       );
  //     } else {
  //       throw ResponseMessage(
  //         ResponseString.RESPONSE_STRING_OPERATION_FAILED,
  //       );
  //     }
  //   } catch (e) {
  //     log.e('operation failure , e: $e');
  //     if (e is MessageHandler) {
  //       emit(state.error(messageHandler: e));
  //     } else {
  //       emit(
  //         state.error(
  //           messageHandler: ResponseMessage(
  //             ResponseString
  //                 .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  void rejectOperation() {
    log.i('beacon connection rejected');
    beacon.operationResponse(
      id: beaconCubit.state.beaconRequest!.request!.id!,
      transactionHash: null,
    );
    emit(state.copyWith(status: AppStatus.success));
  }

  List<Operation> getOperation({required BeaconRequest beaconRequest}) {
    final List<Operation> operations = [];

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

        final dynamic param = operationDetail.parameters != null
            ? jsonDecode(jsonEncode(operationDetail.parameters))
            : null;

        Map<String, dynamic>? parameters;

        if (param != null) {
          parameters = param is List
              ? param[0] as Map<String, dynamic>
              : param as Map<String, dynamic>;
        }

        final operation = TransactionOperation(
            amount: int.parse(amount),
            destination: destination,
            entrypoint: entrypoint,
            params: parameters,
            customFee: fee != null ? int.parse(fee) : null,
            customGasLimit: gasLimit != null ? int.parse(gasLimit) : null,
            customStorageLimit:
                storageLimit != null ? int.parse(storageLimit) : null);

        operations.add(operation);
      }
    }

    return operations;
  }
}
