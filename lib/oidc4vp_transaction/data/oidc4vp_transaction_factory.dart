import 'dart:convert';

import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:altme/oidc4vp_transaction/domain/oidc4vp_transaction.dart';
import 'package:meta/meta.dart';

// Create the proper Oidc4vpTransaction from the transaction_data list.
// Based on factory method
class Oidc4vpTransactionFactory {
  Oidc4vpTransactionFactory({required List<String> transactionData}) {
    transactionList = decodeTransactions(transactionData);
  }

  late List<Oidc4vpTransaction> transactionList;

  @visibleForTesting
  List<Oidc4vpTransaction> decodeTransactions(List<String> transactionData) {
    final List<Oidc4vpTransaction> decodedTransactions = [];
    for (final tx in transactionData) {
      final decodedString = utf8.decode(decodeEncodedList(tx));
      final decodedMap = json.decode(decodedString) as Map<String, dynamic>;
      final type = transactionType(decodedMap);
      switch (type) {
        case TransactionType.cryptoPayment:
          decodedTransactions.add(
            PaymentTransaction(transactionJson: decodedMap),
          );
        case TransactionType.textSignature:
          decodedTransactions.add(
            SignatureTransaction(transactionJson: decodedMap),
          );
      }
    }
    return decodedTransactions;
  }

  @visibleForTesting
  TransactionType transactionType(Map<String, dynamic> decodedMap) {
    try {
      return TransactionType.values.byName(decodedMap['type'] as String);
    } catch (_) {
      return TransactionType.cryptoPayment;
    }
  }
}
