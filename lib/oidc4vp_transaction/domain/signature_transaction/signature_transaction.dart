part of '../oidc4vp_transaction.dart';

class SignatureTransaction extends Oidc4vpTransaction {
  SignatureTransaction({required super.transactionJson});

  @override
  Future<void> prepare() {
    // TODO: implement accept
    throw UnimplementedError();
  }

  @override
  Future<void> cancel() {
    // TODO: implement refuse
    throw UnimplementedError();
  }

  @override
  TransactionType get transactionType => TransactionType.textSignature;

  @override
  Future<void> execute() {
    // TODO: implement execute
    throw UnimplementedError();
  }


}
