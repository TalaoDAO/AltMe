import 'dart:typed_data';

import 'package:altme/app/shared/m_web3_client/m_web3_client.dart';

/// Represents a list of blockchain transactions encoded as base64 strings.
class Oidc4vpSignedTransaction {
  Oidc4vpSignedTransaction({required this.signedTransaction});

  /// List of base64-encoded transaction data strings.
  final List<Uint8List> signedTransaction;

  Future<void> sendToken(String rpcUrl) async {
    for (final signature in signedTransaction) {
      await MWeb3Client.sendEVMTransactionWithSignature(
        signed: signature,
        web3RpcURL: rpcUrl,
      );
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
