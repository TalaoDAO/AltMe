part of '../oidc4vp_transaction.dart';

class SignatureTransaction extends Oidc4vpTransaction {
  SignatureTransaction({required super.transactionJson});

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
  TransactionType get transactionType => TransactionType.textSignature;

  @override
  Future<void> execute() {
    // TODO(hawkbee): implement execute
    throw UnimplementedError();
  }
}
