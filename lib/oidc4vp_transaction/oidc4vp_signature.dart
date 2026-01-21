import 'dart:typed_data';

import 'package:altme/app/shared/m_web3_client/m_web3_client.dart';
import 'package:altme/app/shared/models/blockchain_network/blockchain_network_helpers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Represents a list of blockchain transactions encoded as base64 strings.
class Oidc4vpSignedTransaction {
  Oidc4vpSignedTransaction({
    required this.signedTransaction,
    required this.signedTransactionChainIds,
  });

  /// List of base64-encoded transaction data strings.
  final List<Uint8List> signedTransaction;
  final List<int> signedTransactionChainIds;

  /// The blockchain network associated with the transaction.
  Future<void> sendToken() async {
    var index = 0;
    for (final signature in signedTransaction) {
      final rpcUrl = await fetchRpcUrl(
        blockchainNetwork: blockchainNetworkFromChainId(
          signedTransactionChainIds[index],
        )!,
        dotEnv: DotEnv(),
      );
      await MWeb3Client.sendEVMTransactionWithSignature(
        signed: signature,
        web3RpcURL: rpcUrl,
      );
      index++;
    }
    return;
  }

  List<String> getSignedTransactionHashes() {
    final List<String> signedTransactionHashes = [];
    for (final signature in signedTransaction) {
      signedTransactionHashes.add(
        MWeb3Client.convertSignatureToStringHash(signature),
      );
    }
    return signedTransactionHashes;
  }
}
