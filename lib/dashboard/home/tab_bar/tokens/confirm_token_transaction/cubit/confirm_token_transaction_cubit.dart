// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:math';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/models/blockchain_network/blockchain_network_helpers.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';

import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tezart/tezart.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';

part 'confirm_token_transaction_state.dart';

class ConfirmTokenTransactionCubit extends Cubit<ConfirmTokenTransactionState> {
  ConfirmTokenTransactionCubit({
    required ConfirmTokenTransactionState initialState,
    required this.manageNetworkCubit,
    required this.client,
    required this.keyGenerator,
    required this.walletCubit,
  }) : super(initialState);

  final ManageNetworkCubit manageNetworkCubit;
  final DioClient client;
  final KeyGenerator keyGenerator;
  final WalletCubit walletCubit;

  final logger = getLogger('ConfirmWithdrawal');

  Future<void> getXtzUSDPrice() async {
    await dotenv.load();
    final apiKey = dotenv.get('COIN_GECKO_API_KEY');

    final responseOfXTZUsdPrice =
        await client.get(
              '${Urls.coinGeckoBase}simple/price?ids=tezos&vs_currencies=usd',
              queryParameters: {'x_cg_demo_api_key': apiKey},
            )
            as Map<String, dynamic>;
    final xtzUSDPrice = responseOfXTZUsdPrice['tezos']['usd'] as double;
    emit(
      state.copyWith(
        networkFee: state.networkFee!.copyWith(
          feeInUSD:
              xtzUSDPrice *
              Decimal.parse(state.networkFee!.totalFee).toDouble(),
        ),
        networkFees: state.networkFees!
            .map(
              (e) => e.copyWith(
                feeInUSD: xtzUSDPrice * Decimal.parse(e.totalFee).toDouble(),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<double?> getEVMUSDPrice(BlockchainType blockchainType) async {
    try {
      final symbol = blockchainType.symbol;
      final dynamic response = await client.get(
        '${Urls.cryptoCompareBaseUrl}/data/price?fsym=$symbol&tsyms=USD',
      );
      if (response['USD'] != null) {
        final tokenUSDPrice = response['USD'] as double;
        return tokenUSDPrice;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> calculateFee() async {
    if (state.withdrawalAddress.trim().isEmpty) return;
    emit(state.loading());
    try {
      if (manageNetworkCubit.state.network is TezosNetwork) {
        await _calculateFeeTezos();
        unawaited(getXtzUSDPrice());
      } else {
        await _calculateEVMFee();
      }
    } catch (e, s) {
      logger.i('error: $e , stack: $s');
      emit(state.copyWith(status: AppStatus.error));
      emit(state.copyWith(status: AppStatus.goBack));
    }
  }

  BigInt? gas;
  EtherAmount? gasPrice;

  Future<void> _calculateEVMFee() async {
    gas = null;
    gasPrice = null;
    final blockchainType = walletCubit.state.currentAccount?.blockchainType;

    if (blockchainType == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Please set the blockchain type first.',
        },
      );
    }

    final amount = Decimal.parse(
      state.tokenAmount.replaceAll('.', '').replaceAll(',', ''),
    ).toBigInt();

    final credentials = EthPrivateKey.fromHex(state.selectedAccountSecretKey);
    final sender = credentials.address;
    final reciever = EthereumAddress.fromHex(state.withdrawalAddress);

    final web3RpcURL = await fetchRpcUrl(
      blockchainNetwork: manageNetworkCubit.state.network,
      dotEnv: dotenv,
    );

    final (maxGas, priceOfGas, feeData) = await MWeb3Client.estimateEVMFee(
      web3RpcURL: web3RpcURL,
      sender: sender,
      reciever: reciever,
      amount: EtherAmount.inWei(
        state.selectedToken.symbol.isEVM ? amount : BigInt.zero,
      ),
    );

    gas = maxGas;
    gasPrice = priceOfGas;

    final fee = EtherAmount.inWei(feeData).getValueInUnit(EtherUnit.ether);

    final etherUSDPrice = (await getEVMUSDPrice(blockchainType)) ?? 0;
    final double feeInUSD = etherUSDPrice * fee;

    final networkFee = NetworkFeeModel(
      totalFee: fee.toString(),
      networkSpeed: NetworkSpeed.average,
      tokenSymbol: blockchainType.symbol,
      feeInUSD: feeInUSD,
    );

    emit(
      state.copyWith(
        status: AppStatus.init,
        networkFee: networkFee,
        totalAmount: state.selectedToken.symbol == networkFee.tokenSymbol
            ? (Decimal.parse(state.tokenAmount) -
                      Decimal.parse(networkFee.totalFee))
                  .toString()
            : state.tokenAmount,
      ),
    );
  }

  late String rpcNodeUrlForTransaction;

  /// Endpoints already tried for the current transaction, so a retry never
  /// hits the same unreachable node again.
  final Set<String> _triedRpcNodeUrls = <String>{};

  /// Moves [rpcNodeUrlForTransaction] onto an endpoint that has not been tried
  /// yet for this transaction. Returns false when every endpoint was tried.
  bool _advanceRpcNodeUrl() {
    final dynamic rpcNodeUrl = manageNetworkCubit.state.network.rpcNodeUrl;
    if (rpcNodeUrl is! List<String>) return false;

    final remaining = rpcNodeUrl
        .where((url) => !_triedRpcNodeUrls.contains(url))
        .toList();
    if (remaining.isEmpty) return false;

    rpcNodeUrlForTransaction = remaining[Random().nextInt(remaining.length)];
    _triedRpcNodeUrls.add(rpcNodeUrlForTransaction);
    logger.i('retrying on a different rpcNodeUrl: $rpcNodeUrlForTransaction');
    return true;
  }

  Future<void> _calculateFeeTezos() async {
    int retryCount = 0;
    const maxRetries = Parameters.maxEntries;

    while (retryCount < maxRetries) {
      try {
        emit(state.loading());

        final dynamic rpcNodeUrl = manageNetworkCubit.state.network.rpcNodeUrl;

        if (rpcNodeUrl is List<String>) {
          rpcNodeUrlForTransaction =
              rpcNodeUrl[Random().nextInt(rpcNodeUrl.length)];
        } else {
          rpcNodeUrlForTransaction = rpcNodeUrl.toString();
        }

        logger.i('rpcNodeUrl: $rpcNodeUrlForTransaction');
        _triedRpcNodeUrls.add(rpcNodeUrlForTransaction);
        final client = TezartClient(rpcNodeUrlForTransaction);
        final keystore = KeyGenerator().getKeystore(
          secretKey: state.selectedAccountSecretKey,
        );
        late OperationsList? finalOperationList;
        final List<NetworkFeeModel> tezosNetworkFees = [];
        late NetworkFeeModel networkFee;
        if (state.selectedToken.contractAddress.isEmpty) {
          finalOperationList = await tezosTransfert(keystore, client);
          final finalTotalFeesSum = finalOperationList.operations.fold(
            0,
            (sum, element) => sum + element.totalFee,
          );
          final finalBakerFeesSum = finalOperationList.operations.fold(
            0,
            (sum, element) => sum + element.fee,
          );

          networkFee = NetworkFeeModel(
            totalFee: (finalTotalFeesSum / 1000000).toString(),
            bakerFee: (finalBakerFeesSum / 1000000).toString(),
            networkSpeed: NetworkSpeed.average,
          );

          tezosNetworkFees.add(networkFee);
        } else {
          // Need to convert michelson expression into michelson

          finalOperationList = await _calculateMichelsonContractFee(
            client,
            keystore,
          );
          if (finalOperationList != null) {
            final finalTotalFeesSum = finalOperationList.operations.fold(
              0,
              (sum, element) => sum + element.totalFee,
            );
            final finalBakerFeesSum = finalOperationList.operations.fold(
              0,
              (sum, element) => sum + element.fee,
            );

            networkFee = NetworkFeeModel(
              totalFee: (finalTotalFeesSum / 1000000).toString(),
              bakerFee: (finalBakerFeesSum / 1000000).toString(),
              networkSpeed: NetworkSpeed.average,
            );
          } else {
            // tezosNetworkFees = NetworkFeeModel.tezosNetworkFees(
            //   slow: '0.002496',
            //   average: '0.021900',
            //   fast: '0.050000',
            // );

            networkFee = const NetworkFeeModel(
              totalFee: '0.021900',
              networkSpeed: NetworkSpeed.average,
            );
          }
          tezosNetworkFees.add(networkFee);
          finalOperationList = null;
        }
        emit(
          state.copyWith(
            networkFee: networkFee,
            networkFees: tezosNetworkFees,
            status: AppStatus.init,
            totalAmount: state.selectedToken.symbol == networkFee.tokenSymbol
                ? (Decimal.parse(state.tokenAmount) -
                          Decimal.parse(networkFee.totalFee))
                      .toString()
                : state.tokenAmount,
            operationsList: finalOperationList,
          ),
        );
        break;
      } catch (e, s) {
        logger.e('error : $e, s: $s');

        if (e is MessageHandler) {
          rethrow;
        } else if (e is TezartNodeError) {
          logger.e('e: $e , metadata: ${e.metadata} , s: $s');
          retryCount++;
          logger.i('retryCount: $retryCount');
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
  }

  // This function estimates fees for Michelson-based contract transactions
  Future<OperationsList?> _calculateMichelsonContractFee(
    TezartClient client,
    Keystore keystore,
  ) async {
    try {
      return await tezosContract(client, keystore);
    } catch (e) {
      logger.e('Michelson contract fee estimation error: $e');
      return null;
    }
  }

  /// Builds `transfer` entrypoint parameters as the native Dart structures
  /// tezart's MichelineEncoder expects (a Map keyed by the type's annotations,
  /// or a List for a Michelson `list`). Passing a Michelson source string
  /// instead fails with
  /// "type 'String' is not a subtype of type 'List<dynamic>'".
  ///
  /// FA1.2 (TZIP-7):
  ///   (pair (address %from) (pair (address %to) (nat %value)))
  /// FA2 (TZIP-12):
  ///   list (pair (address %from_)
  ///              (list %txs (pair (address %to_)
  ///                               (pair (nat %token_id) (nat %amount)))))
  dynamic _buildTransferParams({
    required bool isFA1,
    required String from,
    required String to,
    required int amount,
    required int tokenId,
  }) {
    if (isFA1) {
      return <String, dynamic>{'from': from, 'to': to, 'value': amount};
    }
    return <dynamic>[
      <String, dynamic>{
        'from_': from,
        'txs': <dynamic>[
          <String, dynamic>{'to_': to, 'token_id': tokenId, 'amount': amount},
        ],
      },
    ];
  }

  Future<OperationsList> tezosContract(
    TezartClient client,
    Keystore keystore,
  ) async {
    final contract = Contract(
      contractAddress: state.selectedToken.contractAddress,
      rpcInterface: client.rpcInterface,
    );
    // Use the token's own decimals, as the real transfer does, so the
    // estimate reflects the operation that will actually be sent.
    final amount =
        (double.parse(state.tokenAmount) *
                pow(10, int.parse(state.selectedToken.decimals)))
            .toInt();
    final parameters = _buildTransferParams(
      isFA1: state.selectedToken.isFA1,
      from: keystore.address,
      to: state.withdrawalAddress,
      amount: amount,
      tokenId: int.parse(state.selectedToken.tokenId ?? '0'),
    );

    final finalOperationList = await contract.callOperation(
      entrypoint: 'transfer',
      // A token transfer carries no XTZ; the value moves inside `params`.
      amount: 0,
      params: parameters,
      source: keystore,
      publicKey: keystore.publicKey,
    );

    // callOperation only *builds* the operation list; every Operation still
    // has its initial `fee`/`totalFee` of 0 until the list is estimated.
    // Without this the fee shown to the user, and the customFee handed to the
    // send below, were both zero -- and a zero-fee operation is refused by
    // the mempool, so it was injected, never included, and the account
    // counter never moved.
    await finalOperationList.estimate();

    return finalOperationList;
  }

  Future<OperationsList> tezosTransfert(
    Keystore keystore,
    TezartClient client,
  ) async {
    const minFeesWithStorage = 6526;
    var transactionAmount =
        ((double.parse(state.tokenAmount) * 1000000).toInt()) -
        minFeesWithStorage;
    // Get fees
    final OperationsList estimationOperationList = await prepareTezosOperation(
      keystore,
      client,
      transactionAmount,
    );
    final initialFeesSum = estimationOperationList.operations.fold(
      0,
      (sum, element) => sum + element.totalFee,
    );
    // get final operation
    // minus 1 to prevent overflow operation :-/
    // but it prevent burning gas for nothing.
    transactionAmount =
        transactionAmount - initialFeesSum + minFeesWithStorage - 1;
    final finalOperationList = await prepareTezosOperation(
      keystore,
      client,
      transactionAmount,
    );
    return finalOperationList;
  }

  Future<OperationsList> prepareTezosOperation(
    Keystore keystore,
    TezartClient client,
    int transactionAmount,
  ) async {
    final operationList = OperationsList(
      source: keystore,
      publicKey: keystore.publicKey,
      rpcInterface: client.rpcInterface,
    );
    final isReveal = await client.isKeyRevealed(keystore.address);
    if (!isReveal) {
      operationList.prependOperation(RevealOperation());
    }
    final transactionOperation = TransactionOperation(
      amount: transactionAmount,
      destination: state.withdrawalAddress,
    );
    operationList.appendOperation(transactionOperation);

    await operationList.estimate();
    await operationList.simulate();
    return operationList;
  }

  void setWithdrawalAddress({required String withdrawalAddress}) {
    emit(state.copyWith(withdrawalAddress: withdrawalAddress));
  }

  void setNetworkFee({required NetworkFeeModel networkFee}) {
    final totalAmount = state.selectedToken.symbol == networkFee.tokenSymbol
        ? (Decimal.parse(state.tokenAmount) -
                  Decimal.parse(networkFee.totalFee))
              .toString()
        : state.tokenAmount;

    emit(state.copyWith(networkFee: networkFee, totalAmount: totalAmount));
  }

  bool canConfirmTheWithdrawal() {
    return Decimal.parse(state.totalAmount) > Decimal.parse('0') &&
        state.withdrawalAddress.trim().isNotEmpty &&
        state.status != AppStatus.loading;
  }

  Future<void> _withdrawTezos() async {
    try {
      emit(state.loading());
      unawaited(state.operationsList!.executeAndMonitor(null));
      logger.i('after withdrawal execute');
      emit(state.success());
    } catch (e, s) {
      logger.e(
        'error after withdrawal execute: e: $e, stack: $s',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> _withdrawEthereumBaseTokenByChainId({
    required String tokenAmount,
    required String selectedAccountSecretKey,
  }) async {
    emit(state.loading());
    final selectedEthereumNetwork =
        manageNetworkCubit.state.network as EthereumNetwork;

    final rpcNodeUrl = selectedEthereumNetwork.rpcNodeUrl as String;

    final amount = BigInt.parse(
      tokenAmount
          .decimalNumber(int.parse(selectedEthereumNetwork.mainTokenDecimal))
          .replaceAll('.', '')
          .replaceAll(',', ''),
    );

    getLogger(
      toString(),
    ).i('selected network node rpc: $rpcNodeUrl, amount: $tokenAmount');

    final credentials = EthPrivateKey.fromHex(selectedAccountSecretKey);
    final sender = credentials.address;

    final transactionHash = await MWeb3Client.sendEVMTransaction(
      web3RpcURL: rpcNodeUrl,
      chainId: selectedEthereumNetwork.chainId,
      privateKey: selectedAccountSecretKey,
      sender: sender,
      receiver: EthereumAddress.fromHex(state.withdrawalAddress),
      amount: EtherAmount.inWei(amount),
      gas: gas,
      gasPrice: gasPrice,
    );

    logger.i(
      'sending from: $sender to : ${state.withdrawalAddress},etherAmountInWei: ${EtherAmount.inWei(amount)}',
    );

    logger.i(
      'after withdrawal ETH execute => transactionHash: $transactionHash',
    );
    emit(state.success(transactionHash: transactionHash));
  }

  int transactionAttemptCount = 0;

  void resetTransactionAttemptCount() {
    transactionAttemptCount = 0;
    _triedRpcNodeUrls.clear();
  }

  Future<void> sendContractInvocationOperation() async {
    try {
      transactionAttemptCount++;
      logger.i('attempt $transactionAttemptCount');
      emit(state.loading());

      if (manageNetworkCubit.state.network is TezosNetwork) {
        await _sendContractInvocationOperationTezos(
          tokenAmount: double.parse(state.totalAmount),
          selectedAccountSecretKey: state.selectedAccountSecretKey,
          token: state.selectedToken,
          rpcNodeUrl: rpcNodeUrlForTransaction,
        );
      } else {
        final selectedEthereumNetwork = manageNetworkCubit.state.network;

        final chainRpcUrl = await fetchRpcUrl(
          blockchainNetwork: manageNetworkCubit.state.network,
          dotEnv: dotenv,
        );

        await _sendContractInvocationOperationEVM(
          tokenAmount: state.totalAmount,
          selectedAccountSecretKey: state.selectedAccountSecretKey,
          token: state.selectedToken,
          chainId: (selectedEthereumNetwork as EthereumNetwork).chainId,
          chainRpcUrl: chainRpcUrl,
          rpcUrl: chainRpcUrl,
        );

        resetTransactionAttemptCount();
      }
    } catch (e, s) {
      if (transactionAttemptCount < 3) {
        // Failover: a retry against the same unreachable node would fail
        // identically, so move to an endpoint we have not tried yet.
        _advanceRpcNodeUrl();
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await sendContractInvocationOperation();
        return;
      }
      resetTransactionAttemptCount();
      logger.e(
        'error after withdrawal execute: e: $e, stack: $s',
        error: e,
        stackTrace: s,
      );
      if (e is RPCError) {
        logger.i('rpc error=> e.message: ${e.message} , e.data: ${e.data}');
        emit(
          state.copyWith(
            status: AppStatus.error,
            message: StateMessage.error(
              stringMessage: e.message,
              showDialog: true,
            ),
          ),
        );
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

  Future<void> _sendContractInvocationOperationTezos({
    required double tokenAmount,
    required String selectedAccountSecretKey,
    required TokenModel token,
    required String rpcNodeUrl,
  }) async {
    try {
      if (token.symbol == 'XTZ') {
        await _withdrawTezos();
        return;
      }
      if (token.contractAddress.isEmpty) return;

      emit(state.loading());

      final client = TezartClient(rpcNodeUrl);
      final keystore = KeyGenerator().getKeystore(
        secretKey: selectedAccountSecretKey,
      );

      final contract = Contract(
        contractAddress: token.contractAddress,
        rpcInterface: client.rpcInterface,
      );

      final amount =
          (tokenAmount *
                  double.parse(
                    1
                        .toStringAsFixed(int.parse(token.decimals))
                        .replaceAll('.', ''),
                  ))
              .toInt();

      final parameters = _buildTransferParams(
        isFA1: token.isFA1,
        from: keystore.address,
        to: state.withdrawalAddress,
        amount: amount,
        tokenId: int.parse(token.tokenId ?? '0'),
      );

      getLogger('sendContractInvocationOperation').i(
        'sending from: ${keystore.address}'
        ',to: ${state.withdrawalAddress} ,amountInInt: $amount '
        'amountInDecimal: $tokenAmount tokenSymbol: ${token.symbol}',
      );

      // The baker fee is what the operation's `fee` field must carry.
      // `totalFee` also includes the storage burn, which the protocol charges
      // separately, so using it here would overpay.
      final feeInXtz = state.networkFee?.bakerFee ?? state.networkFee?.totalFee;
      final customFee = feeInXtz == null
          ? 0
          : (Decimal.parse(feeInXtz).toDouble() * 1000000).round();

      final operationList = await contract.callOperation(
        entrypoint: 'transfer',
        // A token transfer carries no XTZ; the value moves inside `params`.
        amount: 0,
        params: parameters,
        source: keystore,
        publicKey: keystore.publicKey,
        // A zero customFee would override tezart's own minimal-fee
        // computation and produce an operation the mempool refuses.
        customFee: customFee > 0 ? customFee : null,
      );

      await operationList.executeAndMonitor(null);

      emit(state.success());
    } catch (e, s) {
      getLogger(
        runtimeType.toString(),
      ).e('error in transferOperation , e: $e, s: $s');

      if (e is TezartNodeError) {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString.RESPONSE_STRING_FAILED_TO_DO_OPERATION,
            ),
          ),
        );
      } else {
        rethrow;
      }
    }
  }

  Future<void> _sendContractInvocationOperationEVM({
    required String tokenAmount,
    required String selectedAccountSecretKey,
    required TokenModel token,
    required int chainId,
    required String chainRpcUrl,
    required String rpcUrl,
  }) async {
    try {
      final ethBalance = await MWeb3Client.getEVMBalance(
        secretKey: state.selectedAccountSecretKey,
        rpcUrl: rpcUrl,
      );

      final totalFee = state.networkFee?.totalFee ?? '0';

      if (Decimal.parse(totalFee).toDouble() > ethBalance) {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE,
            ),
          ),
        );
        return;
      }

      if (token.symbol.isEVM) {
        await _withdrawEthereumBaseTokenByChainId(
          tokenAmount: tokenAmount,
          selectedAccountSecretKey: selectedAccountSecretKey,
        );
        return;
      }
      if (token.contractAddress.isEmpty) return;

      emit(state.loading());

      //final rpcUrl = manageNetworkCubit.state.network.rpcNodeUrl;
      //final rpcUrl = await web3RpcMainnetInfuraURL();
      final amount =
          double.parse(tokenAmount) *
          double.parse(
            1.toStringAsFixed(int.parse(token.decimals)).replaceAll('.', ''),
          );

      final txId = await MWeb3Client.sendToken(
        amountInWei: amount,
        rpcUrl: chainRpcUrl,
        withdrawalAddress: state.withdrawalAddress,
        token: token,
        selectedAccountSecretKey: selectedAccountSecretKey,
        chainId: chainId,
      );

      if (txId != null) {
        emit(state.copyWith(status: AppStatus.success, transactionHash: txId));
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
    } catch (e, s) {
      getLogger(
        runtimeType.toString(),
      ).e('error in transferOperation , e: $e, s: $s');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'ConfirmTokenTransactionCubit';
  }
}
