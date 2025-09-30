import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/tezart.dart';
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
    required this.connectedDappRepository,
    required this.manageNetworkCubit,
  }) : super(const OperationState());

  final WalletCubit walletCubit;
  final Beacon beacon;
  final BeaconCubit beaconCubit;
  final DioClient dioClient;
  final KeyGenerator keyGenerator;
  final NftCubit nftCubit;
  final TokensCubit tokensCubit;
  final WalletConnectCubit walletConnectCubit;
  final ConnectedDappRepository connectedDappRepository;
  final ManageNetworkCubit manageNetworkCubit;

  final log = getLogger('OperationCubit');

  //late WCClient? wcClient;

  Future<void> initialise(ConnectionBridgeType connectionBridgeType) async {
    if (isClosed) return;

    try {
      emit(state.loading());

      String dAppName = '';
      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          dAppName =
              beaconCubit.state.beaconRequest?.request?.appMetadata?.name ?? '';
        case ConnectionBridgeType.walletconnect:
          final List<SavedDappData> savedDapps = await connectedDappRepository
              .findAll();

          final SavedDappData? savedDappData = savedDapps.firstWhereOrNull((
            SavedDappData element,
          ) {
            return walletConnectCubit.state.sessionTopic ==
                element.sessionData!.topic;
          });

          if (savedDappData != null) {
            dAppName = savedDappData.sessionData!.peer.metadata.name;
          }
      }

      log.i('dAppName - $dAppName');

      emit(state.copyWith(dAppName: dAppName));

      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          await getUsdPrice(connectionBridgeType);
        case ConnectionBridgeType.walletconnect:
          final walletConnectState = walletConnectCubit.state;

          var publicKey = '';

          final params = walletConnectState.parameters;

          if (params is List<dynamic>) {
            publicKey = params[0]['from'].toString();
          } else if (params is Map<String, dynamic>) {
            // tezos
            publicKey = params['account'].toString();
          } else {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }

          final CryptoAccountData? currentAccount = walletCubit
              .getCryptoAccountData(publicKey);

          log.i('currentAccount -$currentAccount');
          if (currentAccount == null) {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          } else {
            emit(state.copyWith(cryptoAccountData: currentAccount));

            await getUsdPrice(connectionBridgeType);
          }
      }
    } catch (e) {
      log.e('intialisation , e: $e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  Future<void> getUsdPrice(ConnectionBridgeType connectionBridgeType) async {
    if (isClosed) return;
    try {
      final isTezos =
          connectionBridgeType == ConnectionBridgeType.beacon ||
          (connectionBridgeType == ConnectionBridgeType.walletconnect &&
              state.cryptoAccountData?.blockchainType == BlockchainType.tezos);

      if (isTezos) {
        log.i('fetching xtz USDprice');
        final xtzUsdPrice = await _getTezosCurrentPriceInUSD();
        emit(state.copyWith(usdRate: xtzUsdPrice));
      } else {
        log.i('fetching evm USDprice');

        final symbol = state.cryptoAccountData!.blockchainType.symbol;

        final response =
            await dioClient.get(Urls.ethPrice(symbol)) as Map<String, dynamic>;
        log.i('response - $response');
        final double usdRate = response['USD'] as double;
        emit(state.copyWith(usdRate: usdRate));
      }

      await getOtherPrices(connectionBridgeType);
    } catch (e) {
      log.e('getUsdPrice failure , e: $e');
      if (e is MessageHandler) {
        emit(
          state.copyWith(
            status: AppStatus.errorWhileFetching,
            message: StateMessage.error(messageHandler: e),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppStatus.errorWhileFetching,
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                message: ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<double?> _getTezosCurrentPriceInUSD() async {
    try {
      await dotenv.load();
      final apiKey = dotenv.get('COIN_GECKO_API_KEY');

      final responseOfXTZUsdPrice =
          await dioClient.get(
                '${Urls.coinGeckoBase}simple/price?ids=tezos&vs_currencies=usd',
                queryParameters: {'x_cg_demo_api_key': apiKey},
              )
              as Map<String, dynamic>;
      return responseOfXTZUsdPrice['tezos']['usd'] as double;
    } catch (_) {
      return null;
    }
  }

  Future<void> getOtherPrices(ConnectionBridgeType connectionBridgeType) async {
    if (isClosed) return;
    try {
      emit(state.loading());
      log.i('estimateOperationFee');

      late String amount;
      late String totalFee;
      String? bakerFee;

      final BeaconRequest? beaconRequest = beaconCubit.state.beaconRequest;
      final List<OperationDetails>? tezosOperationDetails =
          walletConnectCubit.state.operationDetails;

      final Transaction? transaction = walletConnectCubit.state.transaction;

      /// Error cases
      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          if (beaconRequest == null) {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
        case ConnectionBridgeType.walletconnect:
          if (tezosOperationDetails == null && transaction == null) {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
      }

      if (beaconRequest != null || tezosOperationDetails != null) {
        late List<OperationDetails> operationDetails;
        late String sourceAddress;
        NetworkType? networkType;

        if (beaconRequest != null) {
          operationDetails = beaconRequest.operationDetails!;
          sourceAddress = beaconRequest.request!.sourceAddress!;
          networkType = beaconRequest.request?.network?.type;
        } else {
          operationDetails = tezosOperationDetails!;
          sourceAddress = operationDetails.first.source!;

          // TODO(bibash): check later
          networkType = NetworkType.mainnet;
        }

        if (networkType == null) {
          throw ResponseMessage(
            message: ResponseString
                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
        }

        final amountData = int.parse(operationDetails.first.amount!);

        final destination = operationDetails.first.destination!;

        final operationList = await getTezosOperationList(
          preCheckBalance: true,
          sourceAddress: sourceAddress,
          networkType: networkType,
          amount: amountData,
          destination: destination,
          operationDetails: operationDetails,
        );
        await operationList.estimate();

        log.i('after operationList.estimate()');
        amount = (amountData / 1e6).toString();
        totalFee =
            (operationList.operations
                        .map((Operation e) => e.totalFee)
                        .reduce((int value, int element) => value + element) /
                    1e6)
                .toString();
        bakerFee =
            (operationList.operations
                        .map((Operation e) => e.fee)
                        .reduce((int value, int element) => value + element) /
                    1e6)
                .toString();
        log.i('bakerFee - $bakerFee');
      } else if (transaction != null) {
        final EtherAmount ethAmount = transaction.value!;
        amount = MWeb3Client.formatEthAmount(
          amount: ethAmount.getInWei,
        ).toString();

        final web3RpcURL = await fetchRpcUrl(
          blockchainNetwork: manageNetworkCubit.state.network,
          dotEnv: dotenv,
        );
        log.i('web3RpcURL - $web3RpcURL');

        final (_, _, feeData) = await MWeb3Client.estimateEVMFee(
          web3RpcURL: web3RpcURL,
          sender: transaction.from!,
          reciever: transaction.to!,
          amount: ethAmount,
          data: transaction.data == null
              ? null
              : utf8.decode(transaction.data!),
        );

        totalFee = MWeb3Client.formatEthAmount(amount: feeData).toString();
      }

      log.i('amount - $amount');
      log.i('totalFee - $totalFee');

      emit(
        state.copyWith(
          status: AppStatus.idle,
          amount: amount,
          totalFee: totalFee,
          bakerFee: bakerFee,
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
                messageHandler: ResponseMessage(message: responseString),
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AppStatus.errorWhileFetching,
              message: StateMessage.error(
                messageHandler: ResponseMessage(
                  message: ResponseString.RESPONSE_STRING_OPERATION_FAILED,
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
                message: ResponseString.RESPONSE_STRING_OPERATION_COMPLETED,
              ),
            ),
          ),
        );
      }
    }
  }

  int operationAttemptCount = 0;

  void resetOperationAttemptCount() {
    operationAttemptCount = 0;
  }

  Future<void> sendOperataion(ConnectionBridgeType connectionBridgeType) async {
    if (isClosed) return;
    try {
      emit(state.loading());
      operationAttemptCount++;
      log.i('sendOperataion attempt $operationAttemptCount');

      final isInternetAvailable = await isConnectedToInternet();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      final BeaconRequest? beaconRequest = beaconCubit.state.beaconRequest;
      final List<OperationDetails>? tezosOperationDetails =
          walletConnectCubit.state.operationDetails;

      final Transaction? transaction = walletConnectCubit.state.transaction;

      /// Error cases
      switch (connectionBridgeType) {
        case ConnectionBridgeType.beacon:
          if (beaconRequest == null) {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
        case ConnectionBridgeType.walletconnect:
          if (tezosOperationDetails == null && transaction == null) {
            throw ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
      }

      late bool success;

      if (beaconRequest != null || tezosOperationDetails != null) {
        late List<OperationDetails> operationDetails;
        late String sourceAddress;
        NetworkType? networkType;

        if (beaconRequest != null) {
          operationDetails = beaconRequest.operationDetails!;
          sourceAddress = beaconRequest.request!.sourceAddress!;
          networkType = beaconRequest.request?.network?.type;
        } else {
          operationDetails = tezosOperationDetails!;
          sourceAddress = operationDetails.first.source!;

          // TODO(bibash): check later
          networkType = NetworkType.mainnet;
        }

        if (networkType == null) {
          throw ResponseMessage(
            message: ResponseString
                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
        }

        final amountData = int.parse(operationDetails.first.amount!);
        final destination = operationDetails.first.destination!;

        final operationList = await getTezosOperationList(
          preCheckBalance: true,
          sourceAddress: sourceAddress,
          networkType: networkType,
          amount: amountData,
          destination: destination,
          operationDetails: operationDetails,
        );
        await operationList.executeAndMonitor(null);
        log.i('after operationList.executeAndMonitor()');

        final transactionHash = operationList.result.id;
        log.i('transactionHash - $transactionHash');

        if (beaconRequest != null) {
          final Map<dynamic, dynamic> response = await beacon.operationResponse(
            id: beaconCubit.state.beaconRequest!.request!.id!,
            transactionHash: transactionHash,
          );

          success = json.decode(response['success'].toString()) as bool;
        } else {
          walletConnectCubit.completer[walletConnectCubit.completer.length - 1]!
              .complete(transactionHash);
          success = true;
        }
      } else if (transaction != null) {
        final CryptoAccountData transactionAccountData =
            state.cryptoAccountData!;

        final EtherAmount ethAmount = transaction.value!;

        final rpcUrl = await fetchRpcUrl(
          blockchainNetwork: manageNetworkCubit.state.network,
          dotEnv: dotenv,
        );

        log.i('rpcUrl - $rpcUrl');

        final String transactionHash = await MWeb3Client.sendEVMTransaction(
          chainId: transactionAccountData.blockchainType.chainId,
          web3RpcURL: rpcUrl,
          privateKey: transactionAccountData.secretKey,
          sender: transaction.from!,
          reciever: transaction.to!,
          amount: ethAmount,
          data: transaction.data == null
              ? null
              : utf8.decode(transaction.data!),
        );

        walletConnectCubit.completer[walletConnectCubit.completer.length - 1]!
            .complete(transactionHash);
        success = true;
      }

      if (success) {
        log.i('operation success');
        emit(
          state.copyWith(
            status: AppStatus.success,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                message: ResponseString.RESPONSE_STRING_OPERATION_COMPLETED,
              ),
            ),
          ),
        );
        unawaited(nftCubit.fetchFromZero());
        unawaited(tokensCubit.fetchFromZero());
        resetOperationAttemptCount();
      } else {
        throw ResponseMessage(
          message: ResponseString.RESPONSE_STRING_OPERATION_FAILED,
        );
      }
    } catch (e) {
      if (operationAttemptCount < 3) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await sendOperataion(connectionBridgeType);
        return;
      }
      resetOperationAttemptCount();

      log.e('sendOperataion , e: $e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else if (e is TezartNodeError) {
        final Map<String, String> json = e.metadata;
        if (json['reason'] == 'contract.balance_too_low') {
          emit(
            state.error(
              messageHandler: ResponseMessage(
                message: ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE,
              ),
            ),
          );
        } else {
          emit(
            state.error(
              messageHandler: ResponseMessage(
                message: ResponseString.RESPONSE_STRING_OPERATION_FAILED,
              ),
            ),
          );
        }
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString.RESPONSE_STRING_OPERATION_FAILED,
            ),
          ),
        );
      }

      if (connectionBridgeType == ConnectionBridgeType.walletconnect) {
        walletConnectCubit.completer[walletConnectCubit.completer.length - 1]!
            .complete('Failed');
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
      case ConnectionBridgeType.walletconnect:
        log.i('walletconnect  connection rejected');
        if (walletConnectCubit.completer.isNotEmpty) {
          walletConnectCubit.completer[walletConnectCubit.completer.length - 1]!
              .complete('Failed');
        }
    }

    emit(state.copyWith(status: AppStatus.goBack));
  }

  String? rpcNodeUrlForTransaction;

  Future<OperationsList> getTezosOperationList({
    required bool preCheckBalance,
    required String sourceAddress,
    required NetworkType networkType,
    required int amount,
    required String destination,
    required List<OperationDetails> operationDetails,
  }) async {
    int retryCount = 0;
    const maxRetries = Parameters.maxEntries;
    while (retryCount < maxRetries) {
      try {
        log.i('getOperationList');

        final CryptoAccountData? currentAccount = walletCubit
            .getCryptoAccountData(sourceAddress);

        if (currentAccount == null) {
          throw ResponseMessage(
            message: ResponseString
                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
        }

        late String baseUrl;

        if (networkType == NetworkType.mainnet) {
          baseUrl = TezosNetwork.mainNet().apiUrl;
          final rpcNodeUrlList =
              TezosNetwork.mainNet().rpcNodeUrl as List<String>;

          rpcNodeUrlForTransaction ??=
              rpcNodeUrlList[Random().nextInt(rpcNodeUrlList.length)];
        } else if (networkType == NetworkType.ghostnet) {
          baseUrl = TezosNetwork.ghostnet().apiUrl;
          rpcNodeUrlForTransaction =
              TezosNetwork.ghostnet().rpcNodeUrl as String;
        } else {
          throw ResponseMessage(
            message: ResponseString
                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
        }

        // TezartError also handles low balance

        if (preCheckBalance) {
          /// check xtz balance
          log.i('checking xtz');
          final int balance =
              await dioClient.get('$baseUrl/v1/accounts/$sourceAddress/balance')
                  as int;
          log.i('total xtz - $balance');
          final formattedBalance = int.parse(
            balance.toStringAsFixed(6).replaceAll('.', '').replaceAll(',', ''),
          );

          if (amount >= formattedBalance) {
            emit(
              state.copyWith(
                message: StateMessage.error(
                  messageHandler: ResponseMessage(
                    message: ResponseString
                        .RESPONSE_STRING_transactionIsLikelyToFail,
                  ),
                ),
              ),
            );
          }
        }

        final client = TezartClient(rpcNodeUrlForTransaction!);
        final keystore = keyGenerator.getKeystore(
          secretKey: currentAccount.secretKey,
        );

        final operationList = OperationsList(
          source: keystore,
          publicKey: keystore.publicKey,
          rpcInterface: client.rpcInterface,
        );

        final List<Operation> operations = getTezosOperation(operationDetails);
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
          'networkFee: ${state.totalFee} '
          'bakerFee: ${state.bakerFee} '
          'address: ${keystore.address} =>To address: '
          '$destination',
        );

        return operationList;
      } catch (e, s) {
        log.e('error : $e, s: $s');
        retryCount++;
        log.i('retryCount: $retryCount');

        if (e is MessageHandler) {
          rethrow;
        } else if (e is TezartNodeError) {
          log.e('e: $e , metadata: ${e.metadata} , s: $s');
          if (retryCount < maxRetries) {
            await Future<void>.delayed(const Duration(seconds: 1));
          } else {
            rethrow;
          }
        } else {
          throw ResponseMessage(
            message: ResponseString.RESPONSE_STRING_OPERATION_FAILED,
          );
        }
      }
    }

    throw ResponseMessage(
      message: ResponseString.RESPONSE_STRING_OPERATION_FAILED,
    );
  }

  List<Operation> getTezosOperation(List<OperationDetails> operationDetails) {
    final List<Operation> operations = [];

    for (final operationDetail in operationDetails) {
      final String? storageLimit = operationDetail.storageLimit;
      final String? gasLimit = operationDetail.gasLimit;
      final String? fee = operationDetail.fee;

      if (operationDetail.kind == OperationKind.origination) {
        final String balance = operationDetail.amount ?? '0';
        final List<Map<String, dynamic>> code = operationDetail.code!;
        final dynamic storage = operationDetail.storage;

        final operation = OriginationOperation(
          balance: int.parse(balance),
          code: code,
          storage: storage,
          customFee: fee != null ? int.parse(fee) : null,
          customGasLimit: gasLimit != null ? int.parse(gasLimit) : null,
          customStorageLimit: storageLimit != null
              ? int.parse(storageLimit)
              : null,
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
          customStorageLimit: storageLimit != null
              ? int.parse(storageLimit)
              : null,
        );

        operations.add(operation);
      }
    }

    log.i('operations - $operations');
    return operations;
  }
}
