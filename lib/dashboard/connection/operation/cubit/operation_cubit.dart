import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:tezart/tezart.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/web3dart.dart';

part 'operation_cubit.g.dart';
part 'operation_state.dart';

class OperationCubit extends Cubit<OperationState> {
  OperationCubit({
    required this.walletCubit,
    required this.beacon,
    required this.beaconCubit,
    required this.dioClient,
    required this.keyGenerator,
    required this.nftCubit,
    required this.tokensCubit,
    required this.walletConnectCubit,
  }) : super(const OperationState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final DioClient dioClient;
  final KeyGenerator keyGenerator;
  final NftCubit nftCubit;
  final TokensCubit tokensCubit;
  final WalletConnectCubit walletConnectCubit;

  final log = getLogger('OperationCubit');

  Future<void> getUsdPrice(ConnectionBridgeType connectionBridgeType) async {
    if (isClosed) return;
    try {
      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          log.i('fetching xtz USDprice');
          final response =
              await dioClient.get(Urls.xtzPrice) as Map<String, dynamic>;
          final XtzData xtzData = XtzData.fromJson(response);
          log.i('response - ${xtzData.toJson()}');
          emit(state.copyWith(usdRate: xtzData.price));
          break;
        case ConnectionBridgeType.walletconnect:
          log.i('fetching eth USDprice');
          final response =
              await dioClient.get(Urls.ethPrice) as Map<String, dynamic>;
          log.i('response - $response');
          final double usdRate = response['USD'] as double;
          emit(state.copyWith(usdRate: usdRate));
          break;
      }
      await getOtherPrices(connectionBridgeType);
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> getOtherPrices(ConnectionBridgeType connectionBridgeType) async {
    if (isClosed) return;
    try {
      emit(state.loading());
      log.i('estimateOperationFee');

      late double amount;
      late double fee;

      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          final operationList =
              await getBeaonOperationList(preCheckBalance: true);
          await operationList.estimate();
          log.i('after operationList.estimate()');
          amount = int.parse(
                beaconCubit
                    .state.beaconRequest!.operationDetails!.first.amount!,
              ) /
              1e6;
          fee = operationList.operations
                  .map((Operation e) => e.totalFee)
                  .reduce((int value, int element) => value + element) /
              1e6;
          break;
        case ConnectionBridgeType.walletconnect:
          final WCEthereumTransaction transaction =
              walletConnectCubit.state.transaction!;
          final EtherAmount ethAmount = EtherAmount.fromUnitAndValue(
            EtherUnit.wei,
            transaction.value ?? 0,
          );
          amount = MWeb3Client.formatEthAmount(amount: ethAmount.getInWei);

          await dotenv.load();
          final String web3RpcURL = dotenv.get('WEB3_RPC_MAINNET_URL');

          final feeData = await MWeb3Client.estimateEthereumFee(
            web3RpcURL: web3RpcURL,
            sender: EthereumAddress.fromHex(transaction.from),
            reciever: EthereumAddress.fromHex(transaction.to!),
            amount: ethAmount,
            data: transaction.data,
          );
          fee = MWeb3Client.formatEthAmount(amount: feeData);
          break;
      }

      log.i('amount - $amount');
      log.i('fee - $fee');

      emit(
        state.copyWith(
          status: AppStatus.idle,
          amount: amount,
          fee: fee,
        ),
      );
    } catch (e) {
      log.e('cost estimation failure , e: $e');
      if (e is MessageHandler) {
        emit(
          state.copyWith(
            status: AppStatus.errorWhileFetching,
            message: StateMessage.error(messageHandler: e),
          ),
        );
      } else if (e is TezartNodeError) {
        final Map<String, String> json = e.metadata;
        log.e('metadata json: $json');
        if (json['reason'] != null) {
          final reason = json['reason']!;
          late ResponseString responseString;
          if (reason == 'contract.balance_too_low') {
            responseString = ResponseString.RESPONSE_STRING_BALANCE_TOO_LOW;
          } else if (reason.contains('contract.cannot_pay_storage_fee')) {
            responseString =
                ResponseString.RESPONSE_STRING_CANNOT_PAY_STORAGE_FEE;
          } else if (reason.contains('prefilter.fees_too_low')) {
            responseString = ResponseString.RESPONSE_STRING_FEE_TOO_LOW;
          } else if (reason.contains('prefilter.fees_too_low_for_mempool')) {
            responseString =
                ResponseString.RESPONSE_STRING_FEE_TOO_LOW_FOR_MEMPOOL;
          } else if (reason.contains('tx_rollup_balance_too_low')) {
            responseString =
                ResponseString.RESPONSE_STRING_TX_ROLLUP_BALANCE_TOO_LOW;
          } else if (reason.contains('tx_rollup_invalid_zero_transfer')) {
            responseString =
                ResponseString.RESPONSE_STRING_TX_ROLLUP_INVALID_ZERO_TRANSFER;
          } else if (reason.contains('tx_rollup_unknown_address')) {
            responseString =
                ResponseString.RESPONSE_STRING_TX_ROLLUP_UNKNOWN_ADDRESS;
          } else if (reason.contains('inactive_chain')) {
            responseString = ResponseString.RESPONSE_STRING_INACTIVE_CHAIN;
          } else {
            responseString = ResponseString
                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER;
          }

          emit(
            state.copyWith(
              status: AppStatus.errorWhileFetching,
              message: StateMessage.error(
                messageHandler: ResponseMessage(responseString),
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AppStatus.errorWhileFetching,
              message: StateMessage.error(
                messageHandler: ResponseMessage(
                  ResponseString.RESPONSE_STRING_OPERATION_FAILED,
                ),
              ),
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: AppStatus.errorWhileFetching,
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_OPERATION_COMPLETED,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> sendOperataion(ConnectionBridgeType connectionBridgeType) async {
    if (isClosed) return;
    try {
      emit(state.loading());
      log.i('sendOperataion');

      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      late bool success;

      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          final operationList =
              await getBeaonOperationList(preCheckBalance: false);
          await operationList.executeAndMonitor(null);
          log.i('after operationList.executeAndMonitor()');

          final transactionHash = operationList.result.id;
          log.i('transactionHash - $transactionHash');

          final Map response = await beacon.operationResponse(
            id: beaconCubit.state.beaconRequest!.request!.id!,
            transactionHash: transactionHash,
          );

          success = json.decode(response['success'].toString()) as bool;
          break;
        case ConnectionBridgeType.walletconnect:
          final walletConnectState = walletConnectCubit.state;
          final wcClient = walletConnectState.wcClients.firstWhereOrNull(
            (element) =>
                element.remotePeerId ==
                walletConnectCubit.state.currentDappPeerId,
          );

          log.i('wcClient -$wcClient');
          if (wcClient == null) {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final CryptoAccountData? currentAccount =
              walletCubit.state.cryptoAccount.data.firstWhereOrNull(
            (element) =>
                element.walletAddress == walletConnectState.transaction!.from,
          );

          log.i('currentAccount -$currentAccount');
          if (currentAccount == null) {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final WCEthereumTransaction transaction =
              walletConnectCubit.state.transaction!;
          final EtherAmount ethAmount = EtherAmount.fromUnitAndValue(
            EtherUnit.wei,
            transaction.value ?? 0,
          );

          await dotenv.load();
          final String web3RpcURL = dotenv.get('WEB3_RPC_MAINNET_URL');
          final chainId = int.parse(dotenv.get('WEB3_MAINNET_CHAIN_ID'));

          final String transactionHash =
              await MWeb3Client.sendEthereumTransaction(
            chainId: chainId,
            web3RpcURL: web3RpcURL,
            privateKey: currentAccount.secretKey,
            sender: EthereumAddress.fromHex(transaction.from),
            reciever: EthereumAddress.fromHex(transaction.to!),
            amount: ethAmount,
            data: transaction.data,
          );

          wcClient.approveRequest<String>(
            id: walletConnectState.transactionId!,
            result: transactionHash,
          );

          success = true;
          break;
      }

      if (success) {
        log.i('operation success');
        emit(
          state.copyWith(
            status: AppStatus.success,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_OPERATION_COMPLETED,
              ),
            ),
          ),
        );
        unawaited(nftCubit.fetchFromZero());
        unawaited(tokensCubit.fetchFromZero());
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
                ResponseString.RESPONSE_STRING_OPERATION_FAILED,
              ),
            ),
          );
        }
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_OPERATION_FAILED,
            ),
          ),
        );
      }
    }
  }

  void rejectOperation({required ConnectionBridgeType connectionBridgeType}) {
    if (isClosed) return;
    switch (connectionBridgeType) {
      case ConnectionBridgeType.beacon:
        log.i('beacon connection rejected');
        beacon.operationResponse(
          id: beaconCubit.state.beaconRequest!.request!.id!,
          transactionHash: null,
        );
        break;
      case ConnectionBridgeType.walletconnect:
        log.i('walletconnect  connection rejected');
        final walletConnectState = walletConnectCubit.state;

        final wcClient = walletConnectState.wcClients.firstWhereOrNull(
          (element) =>
              element.remotePeerId ==
              walletConnectCubit.state.currentDappPeerId,
        );

        if (wcClient != null) {
          wcClient.rejectRequest(id: walletConnectState.transactionId!);
        }
        break;
    }

    emit(state.copyWith(status: AppStatus.goBack));
  }

  Future<OperationsList> getBeaonOperationList({
    required bool preCheckBalance,
  }) async {
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

      late String baseUrl;
      late String rpcNodeUrl;

      switch (beaconRequest.request!.network!.type!) {
        case NetworkType.mainnet:
          baseUrl = TezosNetwork.mainNet().apiUrl;
          rpcNodeUrl = TezosNetwork.mainNet().rpcNodeUrl;
          break;
        case NetworkType.ghostnet:
          baseUrl = TezosNetwork.ghostnet().apiUrl;
          rpcNodeUrl = TezosNetwork.ghostnet().rpcNodeUrl;
          break;
        case NetworkType.mondaynet:
        case NetworkType.delphinet:
        case NetworkType.edonet:
        case NetworkType.florencenet:
        case NetworkType.granadanet:
        case NetworkType.hangzhounet:
        case NetworkType.ithacanet:
        case NetworkType.jakartanet:
        case NetworkType.kathmandunet:
        case NetworkType.custom:
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
      }

      // TezartError also handles low balance

      if (preCheckBalance) {
        /// check xtz balance
        log.i('checking xtz');
        final int balance = await dioClient.get(
          '$baseUrl/v1/accounts/${beaconRequest.request!.sourceAddress!}/balance',
        ) as int;
        log.i('total xtz - $balance');
        final formattedBalance = int.parse(
          balance.toStringAsFixed(6).replaceAll('.', '').replaceAll(',', ''),
        );

        final amount = int.parse(beaconRequest.operationDetails!.first.amount!);

        if (amount >= formattedBalance) {
          emit(
            state.copyWith(
              message: StateMessage.error(
                messageHandler: ResponseMessage(
                  ResponseString.RESPONSE_STRING_transactionIsLikelyToFail,
                ),
              ),
            ),
          );
        }
      }

      final client = TezartClient(rpcNodeUrl);
      final keystore =
          keyGenerator.getKeystore(secretKey: currentAccount.secretKey);

      final operationList = OperationsList(
        source: keystore,
        publicKey: keystore.publicKey,
        rpcInterface: client.rpcInterface,
      );

      final List<Operation> operations = getBeaonOperation();
      for (final element in operations) {
        operationList.appendOperation(element);
      }

      final isReveal = await client.isKeyRevealed(keystore.address);
      if (!isReveal) {
        operationList.prependOperation(RevealOperation());
      }

      log.i(
        'publicKey: ${keystore.publicKey} '
        'amount: ${state.amount} '
        'networkFee: ${state.fee} '
        'address: ${keystore.address} =>To address: '
        '${beaconRequest.operationDetails!.first.destination!}',
      );

      return operationList;
    } catch (e, s) {
      log.e('error : $e, s: $s');
      if (e is MessageHandler) {
        rethrow;
      } else if (e is TezartNodeError) {
        log.e('e: ${e.toString()} , metadata: ${e.metadata} , s: $s');
        rethrow;
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_OPERATION_FAILED,
        );
      }
    }
  }

  List<Operation> getBeaonOperation() {
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
