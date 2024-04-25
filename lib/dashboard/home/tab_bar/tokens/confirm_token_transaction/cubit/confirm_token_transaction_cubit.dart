// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:math';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:key_generator/key_generator.dart';
import 'package:tezart/tezart.dart';
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

    final responseOfXTZUsdPrice = await client.get(
      '${Urls.coinGeckoBase}simple/price?ids=tezos&vs_currencies=usd',
      queryParameters: {
        'x_cg_pro_api_key': apiKey,
      },
    ) as Map<String, dynamic>;
    final xtzUSDPrice = responseOfXTZUsdPrice['tezos']['usd'] as double;
    emit(
      state.copyWith(
        networkFee: state.networkFee!.copyWith(
          feeInUSD: xtzUSDPrice * state.networkFee!.fee,
        ),
        networkFees: state.networkFees!
            .map(
              (e) => e.copyWith(
                feeInUSD: xtzUSDPrice * e.fee,
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

    final amount =
        Decimal.parse(state.tokenAmount.replaceAll('.', '').replaceAll(',', ''))
            .toBigInt();

    final credentials = EthPrivateKey.fromHex(state.selectedAccountSecretKey);
    final sender = credentials.address;
    final reciever = EthereumAddress.fromHex(state.withdrawalAddress);

    final web3RpcURL = await fetchRpcUrl(manageNetworkCubit.state.network);

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
      fee: fee,
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
                    Decimal.parse(networkFee.fee.toString()))
                .toString()
            : state.tokenAmount,
      ),
    );
  }

  late String rpcNodeUrlForTransaction;

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
        final client = TezartClient(rpcNodeUrlForTransaction);
        final keystore = KeyGenerator()
            .getKeystore(secretKey: state.selectedAccountSecretKey);
        late OperationsList? finalOperationList;
        late List<NetworkFeeModel> tezosNetworkFees;
        late NetworkFeeModel networkFee;
        if (state.selectedToken.contractAddress.isEmpty) {
          finalOperationList = await tezosTransfert(keystore, client);
          final finalFeesSum = finalOperationList.operations
              .fold(0, (sum, element) => sum + element.totalFee);
          tezosNetworkFees = NetworkFeeModel.tezosNetworkFees(
            average: finalFeesSum / 1000000,
          );
          networkFee = tezosNetworkFees[0];
        } else {
          // Need to convert michelson expression into michelson
          // finalOperationList = await tezosContract(
          //   client,
          //   keystore,
          // );
          tezosNetworkFees = NetworkFeeModel.tezosNetworkFees(
            slow: 0.002496,
            average: 0.021900,
            fast: 0.050000,
          );
          finalOperationList = null;
          networkFee = tezosNetworkFees[1];
        }

        emit(
          state.copyWith(
            networkFee: networkFee,
            networkFees: tezosNetworkFees,
            status: AppStatus.init,
            totalAmount: state.selectedToken.symbol == networkFee.tokenSymbol
                ? (Decimal.parse(state.tokenAmount) -
                        Decimal.parse(networkFee.fee.toString()))
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

  Future<OperationsList> tezosContract(
    TezartClient client,
    Keystore keystore,
  ) async {
    final contract = Contract(
      contractAddress: state.selectedToken.contractAddress,
      rpcInterface: client.rpcInterface,
    );
    final amount = (double.parse(state.tokenAmount) * 1000000).toInt();
    final parameters = state.selectedToken.isFA1
        ? '''(Pair "${keystore.publicKey}" (Pair "${state.withdrawalAddress}" $amount))'''
        : '''{Pair "${keystore.publicKey}" {Pair "${state.withdrawalAddress}" (Pair ${int.parse(state.selectedToken.tokenId ?? '0')} $amount)}}''';

    final finalOperationList = await contract.callOperation(
      entrypoint: 'transfer',
      amount: amount,
      params: parameters,
      source: keystore,
      publicKey: keystore.publicKey,
    );
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
    final OperationsList estimationOperationList =
        await prepareTezosOperation(keystore, client, transactionAmount);
    final initialFeesSum = estimationOperationList.operations
        .fold(0, (sum, element) => sum + element.totalFee);
    // get final operation
    // minus 1 to prevent overflow operation :-/
    // but it prevent burning gas for nothing.
    transactionAmount =
        transactionAmount - initialFeesSum + minFeesWithStorage - 1;
    final finalOperationList =
        await prepareTezosOperation(keystore, client, transactionAmount);
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
                Decimal.parse(networkFee.fee.toString()))
            .toString()
        : state.tokenAmount;

    emit(
      state.copyWith(
        networkFee: networkFee,
        totalAmount: totalAmount,
      ),
    );
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
          .decimalNumber(
            int.parse(selectedEthereumNetwork.mainTokenDecimal),
          )
          .replaceAll('.', '')
          .replaceAll(',', ''),
    );

    getLogger(toString())
        .i('selected network node rpc: $rpcNodeUrl, amount: $tokenAmount');

    final credentials = EthPrivateKey.fromHex(selectedAccountSecretKey);
    final sender = credentials.address;

    final transactionHash = await MWeb3Client.sendEVMTransaction(
      web3RpcURL: rpcNodeUrl,
      chainId: selectedEthereumNetwork.chainId,
      privateKey: selectedAccountSecretKey,
      sender: sender,
      reciever: EthereumAddress.fromHex(state.withdrawalAddress),
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

        final chainRpcUrl = await fetchRpcUrl(manageNetworkCubit.state.network);

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

      final sourceKeystore = Keystore.fromSecretKey(selectedAccountSecretKey);

      final keyStore = KeyStoreModel(
        publicKey: sourceKeystore.publicKey,
        secretKey: sourceKeystore.secretKey,
        publicKeyHash: sourceKeystore.address,
      );

      final dynamic signer = await Dartez.createSigner(
        Dartez.writeKeyWithHint(keyStore.secretKey, 'edsk'),
      );

      final List<String> contractAddress = [token.contractAddress];

      // fee calculated by XTZ
      final customFee = int.parse(
        state.networkFee!.fee
            .toStringAsFixed(
              6,
            ) // 6 is because the deciaml of XTZ is alway 6 (mutez)
            .replaceAll('.', '')
            .replaceAll(',', ''),
      );

      final amount = (tokenAmount *
              double.parse(
                1
                    .toStringAsFixed(int.parse(token.decimals))
                    .replaceAll('.', ''),
              ))
          .toInt();

      final parameters = token.isFA1
          ? '''(Pair "${keyStore.publicKeyHash}" (Pair "${state.withdrawalAddress}" $amount))'''
          : '''{Pair "${keyStore.publicKeyHash}" {Pair "${state.withdrawalAddress}" (Pair ${int.parse(token.tokenId ?? '0')} $amount)}}''';

      getLogger('sendContractInvocationOperation').i(
        'sending from: ${keyStore.publicKeyHash}'
        ',to: ${state.withdrawalAddress} ,amountInInt: $amount '
        'amountInDecimal: $tokenAmount tokenSymbol: ${token.symbol}',
      );

      final dynamic resultInvoke = await Dartez.sendContractInvocationOperation(
        rpcNodeUrl,
        signer as SoftSigner,
        keyStore,
        contractAddress,
        [0],
        customFee,
        1000,
        customFee,
        ['transfer'],
        [parameters],
        codeFormat: TezosParameterFormat.Michelson,
      );
      getLogger('sendContractInvocationOperation').i(
        'Operation groupID ===> $resultInvoke',
      );
      if (resultInvoke['appliedOp']['contents'][0]['metadata']
              ['operation_result']['status'] ==
          'failed') {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString.RESPONSE_STRING_FAILED_TO_DO_OPERATION,
            ),
          ),
        );
      } else {
        emit(state.success());
      }
    } catch (e, s) {
      emit(
        state.error(
          messageHandler: ResponseMessage(
            message: ResponseString
                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
      getLogger(runtimeType.toString())
          .e('error in transferOperation , e: $e, s: $s');
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

      if ((state.networkFee?.fee ?? 0) > ethBalance) {
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
      final amount = double.parse(tokenAmount) *
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
      getLogger(runtimeType.toString())
          .e('error in transferOperation , e: $e, s: $s');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'ConfirmTokenTransactionCubit';
  }
}
