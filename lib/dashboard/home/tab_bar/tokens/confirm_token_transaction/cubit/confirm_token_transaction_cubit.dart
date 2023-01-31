// ignore_for_file: lines_longer_than_80_chars

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/tezart.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';

part 'confirm_token_transaction_cubit.g.dart';

part 'confirm_token_transaction_state.dart';

class ConfirmTokenTransactionCubit extends Cubit<ConfirmTokenTransactionState> {
  ConfirmTokenTransactionCubit({
    required ConfirmTokenTransactionState initialState,
    required this.manageNetworkCubit,
    required this.client,
  }) : super(initialState);

  final ManageNetworkCubit manageNetworkCubit;
  final DioClient client;

  final logger = getLogger('ConfirmWithdrawal');

  Future<double?> getXtzUSDPrice() async {
    try {
      final responseOfXTZUsdPrice = await client
          .get('${Urls.tezToolBase}/v1/xtz-price') as Map<String, dynamic>;
      final xtzUSDPrice = responseOfXTZUsdPrice['price'] as double;
      return xtzUSDPrice;
    } catch (_) {
      return null;
    }
  }

  Future<double?> getEthUSDPrice() async {
    try {
      final dynamic response = await client.get(
        '${Urls.cryptoCompareBaseUrl}/data/price?fsym=ETH&tsyms=USD',
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
        final tezosNetworkFees = NetworkFeeModel.tezosNetworkFees();
        final networkFee = tezosNetworkFees[1];
        final XtzUSDPrice = (await getXtzUSDPrice()) ?? 0;
        emit(
          state.copyWith(
            networkFee: networkFee.copyWith(
              feeInUSD: XtzUSDPrice * networkFee.fee,
            ),
            networkFees: tezosNetworkFees
                .map(
                  (e) => e.copyWith(
                    feeInUSD: XtzUSDPrice * e.fee,
                  ),
                )
                .toList(),
            status: AppStatus.init,
            totalAmount: state.selectedToken.symbol == networkFee.tokenSymbol
                ? state.tokenAmount - networkFee.fee
                : state.tokenAmount,
          ),
        );
      } else {
        final web3RpcURL = await web3RpcMainnetInfuraURL();

        final amount = state.tokenAmount
            .toStringAsFixed(int.parse(state.selectedToken.decimals))
            .replaceAll(',', '')
            .replaceAll('.', '');

        final credentials =
            EthPrivateKey.fromHex(state.selectedAccountSecretKey);
        final sender = credentials.address;
        final reciever = EthereumAddress.fromHex(state.withdrawalAddress);

        final maxGas = await MWeb3Client.estimateEthereumFee(
          web3RpcURL: web3RpcURL,
          sender: sender,
          reciever: reciever,
          amount: EtherAmount.inWei(
            state.selectedToken.symbol == 'ETH'
                ? BigInt.from(double.parse(amount))
                : BigInt.zero,
          ),
        );

        final fee = EtherAmount.inWei(maxGas).getValueInUnit(EtherUnit.ether);
        final etherUSDPrice = (await getEthUSDPrice()) ?? 0;
        final double feeInUSD = etherUSDPrice * fee;
        final networkFee = NetworkFeeModel(
          fee: fee,
          networkSpeed: NetworkSpeed.average,
          tokenSymbol: 'ETH',
          feeInUSD: feeInUSD,
        );

        emit(
          state.copyWith(
            status: AppStatus.init,
            networkFee: networkFee,
            totalAmount: state.selectedToken.symbol == networkFee.tokenSymbol
                ? state.tokenAmount - networkFee.fee
                : state.tokenAmount,
          ),
        );
      }
    } catch (e, s) {
      logger.i('error: $e , stack: $s');
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  void setWithdrawalAddress({required String withdrawalAddress}) {
    emit(state.copyWith(withdrawalAddress: withdrawalAddress));
  }

  void setNetworkFee({required NetworkFeeModel networkFee}) {
    final totalAmount = state.selectedToken.symbol == networkFee.tokenSymbol
        ? state.tokenAmount - networkFee.fee
        : state.tokenAmount;

    emit(
      state.copyWith(
        networkFee: networkFee,
        totalAmount: totalAmount,
      ),
    );
  }

  bool canConfirmTheWithdrawal() {
    return state.totalAmount > 0.0 &&
        state.withdrawalAddress.trim().isNotEmpty &&
        state.status != AppStatus.loading;
  }

  Future<void> _withdrawTezos({
    required double tokenAmount,
    required String selectedAccountSecretKey,
  }) async {
    try {
      emit(state.loading());
      final sourceKeystore = Keystore.fromSecretKey(selectedAccountSecretKey);

      final client = TezartClient(manageNetworkCubit.state.network.rpcNodeUrl);

      final amount = int.parse(
        tokenAmount.toStringAsFixed(6).replaceAll(',', '').replaceAll('.', ''),
      );

      final customFee = int.parse(
        state.networkFee!.fee
            .toStringAsFixed(6)
            .replaceAll('.', '')
            .replaceAll(',', ''),
      );

      final operationsList = await client.transferOperation(
        source: sourceKeystore,
        destination: state.withdrawalAddress,
        amount: amount,
        customFee: customFee,
        publicKey: sourceKeystore.publicKey,
      );
      logger.i(
        ' , publicKey: ${sourceKeystore.publicKey} '
        'amount: $amount '
        'networkFee: $customFee '
        'address: ${sourceKeystore.address} =>To address: '
        '${state.withdrawalAddress}',
      );
      // ignore: unawaited_futures
      operationsList.executeAndMonitor(null);
      logger.i('after withdrawal execute');
      emit(state.success());
    } catch (e, s) {
      logger.e('error after withdrawal execute: e: $e, stack: $s', e, s);
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
    }
  }

  Future<void> _withdrawEthereumBaseTokenByChainId({
    required double tokenAmount,
    required String selectedAccountSecretKey,
  }) async {
    try {
      emit(state.loading());
      final selectedEthereumNetwork =
          manageNetworkCubit.state.network as EthereumNetwork;

      final rpcNodeUrl = selectedEthereumNetwork.rpcNodeUrl;

      final amount = int.parse(
        tokenAmount
            .toStringAsFixed(
              int.parse(selectedEthereumNetwork.mainTokenDecimal),
            )
            .replaceAll(',', '')
            .replaceAll('.', ''),
      );

      getLogger(toString())
          .i('selected network node rpc: $rpcNodeUrl, amount: $tokenAmount');

      final credentials = EthPrivateKey.fromHex(selectedAccountSecretKey);
      final sender = credentials.address;

      final transactionHash = await MWeb3Client.sendEthereumTransaction(
        web3RpcURL: rpcNodeUrl,
        chainId: selectedEthereumNetwork.chainId,
        privateKey: selectedAccountSecretKey,
        sender: sender,
        reciever: EthereumAddress.fromHex(state.withdrawalAddress),
        amount: EtherAmount.inWei(BigInt.from(amount)),
      );

      logger.i(
        'sending from: $sender to : ${state.withdrawalAddress},etherAmountInWei: ${EtherAmount.inWei(BigInt.from(amount))}',
      );

      logger.i(
        'after withdrawal ETH execute => transactionHash: $transactionHash',
      );
      emit(state.success(transactionHash: transactionHash));
    } catch (e, s) {
      logger.e('error after withdrawal execute: e: $e, stack: $s', e, s);
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
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  Future<void> sendContractInvocationOperation() async {
    emit(state.copyWith(status: AppStatus.init));
    if (manageNetworkCubit.state.network is TezosNetwork) {
      await _sendContractInvocationOperationTezos(
        tokenAmount: state.totalAmount,
        selectedAccountSecretKey: state.selectedAccountSecretKey,
        token: state.selectedToken,
      );
    } else {
      final selectedEthereumNetwork = manageNetworkCubit.state.network;

      await dotenv.load();
      final ethRpcUrl = dotenv.get('WEB3_RPC_MAINNET_URL');

      String chainRpcUrl = ethRpcUrl;
      if (selectedEthereumNetwork is PolygonNetwork ||
          selectedEthereumNetwork is BinanceNetwork ||
          selectedEthereumNetwork is FantomNetwork) {
        chainRpcUrl = selectedEthereumNetwork.rpcNodeUrl;
      } else {
        chainRpcUrl = ethRpcUrl;
      }
      await _sendContractInvocationOperationEthereum(
        tokenAmount: state.totalAmount,
        selectedAccountSecretKey: state.selectedAccountSecretKey,
        token: state.selectedToken,
        chainId: (selectedEthereumNetwork as EthereumNetwork).chainId,
        chainRpcUrl: chainRpcUrl,
        ethRpcUrl: ethRpcUrl,
      );
    }
  }

  Future<void> _sendContractInvocationOperationTezos({
    required double tokenAmount,
    required String selectedAccountSecretKey,
    required TokenModel token,
  }) async {
    try {
      if (token.symbol == 'XTZ') {
        await _withdrawTezos(
          tokenAmount: tokenAmount,
          selectedAccountSecretKey: selectedAccountSecretKey,
        );
        return;
      }
      if (token.contractAddress.isEmpty) return;

      emit(state.loading());

      final server = manageNetworkCubit.state.network.rpcNodeUrl;

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
        server,
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
              ResponseString.RESPONSE_STRING_FAILED_TO_DO_OPERATION,
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
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
      getLogger(runtimeType.toString())
          .e('error in transferOperation , e: $e, s: $s');
    }
  }

  Future<void> _sendContractInvocationOperationEthereum({
    required double tokenAmount,
    required String selectedAccountSecretKey,
    required TokenModel token,
    required int chainId,
    required String chainRpcUrl,
    required String ethRpcUrl,
  }) async {
    try {
      final ethBalance = await MWeb3Client.getETHBalance(
        secretKey: state.selectedAccountSecretKey,
        rpcUrl: ethRpcUrl,
      );

      if ((state.networkFee?.fee ?? 0) > ethBalance) {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE,
            ),
          ),
        );
        return;
      }

      if (token.symbol == 'ETH' ||
          token.symbol == 'MATIC' ||
          token.symbol == 'FTM' ||
          token.symbol == 'BNB') {
        await _withdrawEthereumBaseTokenByChainId(
          tokenAmount: tokenAmount,
          selectedAccountSecretKey: selectedAccountSecretKey,
        );
        return;
      }
      if (token.contractAddress.isEmpty) return;

      emit(state.loading());

      //final rpcUrl = manageNetworkCubit.state.network.rpcNodeUrl;
      final rpcUrl = await web3RpcMainnetInfuraURL();
      final amount = tokenAmount *
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
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    } catch (e, s) {
      if (e is RPCError) {
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
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
      getLogger(runtimeType.toString())
          .e('error in transferOperation , e: $e, s: $s');
    }
  }

  @override
  String toString() {
    return 'ConfirmTokenTransactionCubit';
  }
}
