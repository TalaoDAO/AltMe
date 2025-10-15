import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/shared/m_web3_client/m_web3_client.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

/// Represents a list of blockchain transactions encoded as base64 strings.
class Oidc4vpTransaction {
  Oidc4vpTransaction({required this.transactionData});

  /// List of base64-encoded transaction data strings.
  final List<dynamic> transactionData;

  Future<List<Uint8List>> getBlockchainSignedTransaction({
    required CryptoAccountData cryptoAccountData,
    required String rpcUrl,
  }) async {
    // Decode all transactions
    final decodedTransactions = decodeTransactions();
    final List<Uint8List> signedTransactions = [];

    for (final tx in decodedTransactions) {
      // Map tx to TokenModel and extract required fields
      final chainId = int.tryParse(tx['chain_id']?.toString() ?? '1') ?? 1;
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

  /// Decodes the base64 transaction data back to a list of Maps.
  List<dynamic> decodeTransactions() {
    final List<dynamic> decodedTransactions = [];
    for (final tx in transactionData) {
      if (tx is String) {
        final decodedString = utf8.decode(decodeEncodedList(tx));
        final decodedMap = json.decode(decodedString) as Map<String, dynamic>;
        decodedTransactions.add(decodedMap);
      }
    }
    return decodedTransactions;
  }
}
