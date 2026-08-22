part of '../oidc4vp_transaction.dart';

class PaymentTransaction extends Oidc4vpTransaction {
  PaymentTransaction({required super.transactionJson});
  final List<Uint8List> signedTransactions = [];
  final List<int> chainIds = [];
  final List<String> blockchainTransactionHashes = [];

  @override
  Future<void> prepare() {
    // TODO(hawkbee): implement accept
    throw UnimplementedError();
  }

  @override
  Future<void> cancel() {
    // TODO(hawkbee): implement refuse
    throw UnimplementedError();
  }

  @override
  TransactionType get transactionType => TransactionType.cryptoPayment;

  Future<void> addBlockchainSignedTransaction({
    required CryptoAccountData cryptoAccountData,
  }) async {
    final dotenv = DotEnv();

    final chainId =
        int.tryParse(transactionJson['chain_id']?.toString() ?? '1') ?? 1;
    final rpcUrl = await fetchRpcUrl(
      blockchainNetwork: blockchainNetworkFromChainId(chainId)!,
      dotEnv: dotenv,
    );
    final params = transactionJson['rpc']['params'] as List<dynamic>;

    for (var i = 0; i < params.length; i++) {
      final param = params[i];
      final amount = param['value']?.toString() ?? '';
      final data = param['data']?.toString() ?? '';
      final receiver = param['to']?.toString() ?? '';
      final transaction = Transaction(
        from: EthereumAddress.fromHex(cryptoAccountData.walletAddress),
        to: EthereumAddress.fromHex(receiver),
        value: EtherAmount.inWei(BigInt.parse(amount)),
        data: data.isNotEmpty ? hexToBytes(data) : null,
      );

      signedTransactions.add(
        await MWeb3Client.getEvmTransactionSignature(
          privateKey: cryptoAccountData.secretKey,
          web3RpcURL: rpcUrl,
          sender: transaction.from!,
          receiver: transaction.to!,
          amount: transaction.value!,
          chainId: chainId,
          data: data,
        ),
      );
      chainIds.add(chainId);
    }
  }

  @override
  Future<void> execute() async {
    final paymentSignature = PaymentSignature(
      signedTransaction: signedTransactions,
      signedTransactionChainIds: chainIds,
    );
    await paymentSignature.sendToken();
    blockchainTransactionHashes.addAll(
      paymentSignature.getSignedTransactionHashes(),
    );
  }
}
