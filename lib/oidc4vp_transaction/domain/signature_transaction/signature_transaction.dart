part of '../oidc4vp_transaction.dart';

class SignatureTransaction extends Oidc4vpTransaction {
  SignatureTransaction({required super.transactionJson});

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
  TransactionType get transactionType => TransactionType.textSignature;


  @override
  Future<List<Uint8List>> getBlockchainSignedTransaction({
    required CryptoAccountData cryptoAccountData,
  }) async {
    throw UnsupportedError(
      'Blockchain transaction signing is not supported for local '
      'signature requests.',
    );
  }

  List<Map<String, dynamic>> decodeLocalSignatureRequests() {
    return decodeTransactions()
        .whereType<Map<String, dynamic>>()
        .where(Oidc4vpTransaction._isLocalSignatureRequest)
        .toList();
  }

  LocalSignRequest? getFirstLocalSignatureRequest() {
    final localRequests = decodeLocalSignatureRequests();
    if (localRequests.isEmpty) {
      return null;
    }
    return LocalSignRequest.fromJson(localRequests.first);
  }
}
