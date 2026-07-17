
part of '../oidc4vp_transaction.dart';

class PaymentTransaction extends Oidc4vpTransaction {
  PaymentTransaction({required super.transactionJson});


@override
  Future<void> accept() {
    // TODO: implement accept
    throw UnimplementedError();
  }
  
  @override
  Future<void> refuse() {
    // TODO: implement refuse
    throw UnimplementedError();
  }
  
  @override
  TransactionType get transactionType => TransactionType.cryptoPayment;
  
    @override
  bool get isLocalSignatureTransaction => false;

  @override
  Future<List<Uint8List>> getBlockchainSignedTransaction({
    required CryptoAccountData cryptoAccountData,
  }) async {
    final decodedTransactions = decodeTransactions();
    final List<Uint8List> signedTransactions = [];
    final dotenv = DotEnv();

    for (final tx in decodedTransactions) {
      final chainId = int.tryParse(tx['chain_id']?.toString() ?? '1') ?? 1;
      final rpcUrl = await fetchRpcUrl(
        blockchainNetwork: blockchainNetworkFromChainId(chainId)!,
        dotEnv: dotenv,
      );
      final params = tx['rpc']['params'] as List<dynamic>;

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
      }
    }
    return signedTransactions;
  }
  
  
}
