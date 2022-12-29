import 'dart:math';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tezart/tezart.dart';
import 'package:web3dart/web3dart.dart';

part 'confirm_token_transaction_cubit.g.dart';

part 'confirm_token_transaction_state.dart';

class ConfirmTokenTransactionCubit extends Cubit<ConfirmTokenTransactionState> {
  ConfirmTokenTransactionCubit({
    required ConfirmTokenTransactionState initialState,
    required this.manageNetworkCubit,
  }) : super(initialState);

  final ManageNetworkCubit manageNetworkCubit;

  final logger = getLogger('ConfirmWithdrawal');

  void setWithdrawalAddress({required String withdrawalAddress}) {
    emit(state.copyWith(withdrawalAddress: withdrawalAddress));
  }

  void setNetworkFee({required NetworkFeeModel networkFee}) {
    emit(state.copyWith(networkFee: networkFee));
  }

  bool canConfirmTheWithdrawal({
    required double amount,
    required TokenModel selectedToken,
  }) {
    // TODO(Taleb): update minimum withdrawal later for every token
    return amount > 0.00001 &&
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
        state.networkFee.fee
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
        'before execute: withdrawal from secretKey: ${sourceKeystore.secretKey}'
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

  Future<void> _withdrawEthereum({
    required double tokenAmount,
    required String selectedAccountSecretKey,
  }) async {
    try {
      emit(state.loading());
      final sourceKeystore = Keystore.fromSecretKey(selectedAccountSecretKey);

      final rpcNodeUrl = manageNetworkCubit.state.network.rpcNodeUrl;

      final amount = int.parse(
        tokenAmount.toStringAsFixed(18).replaceAll(',', '').replaceAll('.', ''),
      );

      final httpClient = Client();
      final ethClient = Web3Client(rpcNodeUrl, httpClient);

      final credentials = EthPrivateKey.fromHex(sourceKeystore.address);

      await ethClient.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(state.withdrawalAddress),
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 100000,
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
        ),
      );
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

  Future<void> sendContractInvocationOperation({
    required double tokenAmount,
    required String selectedAccountSecretKey,
    required TokenModel token,
  }) async {
    if (manageNetworkCubit.state.network is TezosNetwork) {
      await _sendContractInvocationOperationTezos(
        tokenAmount: tokenAmount,
        selectedAccountSecretKey: selectedAccountSecretKey,
        token: token,
      );
    } else if (manageNetworkCubit.state.network is EthereumNetwork) {
      if (token.symbol == 'ETH') {
        await _withdrawEthereum(
          tokenAmount: tokenAmount,
          selectedAccountSecretKey: selectedAccountSecretKey,
        );
        return;
      } else {
        throw Exception('Not Implemented !');
      }
    } else {
      throw Exception('Not Implemented !');
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

      // TODO(all): Do check this getKeysFromSecretKey() in helper function
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
        state.networkFee.fee
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
}
