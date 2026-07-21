import 'dart:convert';

import 'package:altme/oidc4vp_transaction/domain/oidc4vp_transaction.dart';
import 'package:oidc4vc/oidc4vc.dart';

class TransactionData {
  TransactionData({
    required this.transactionData,
    required this.transactions,
  }) {
            for (final element in transactionData) {
          transactionDataHashes.add(sh256Hash(jsonEncode(element)));
        }

  }

  late List<String> transactionDataHashes = [];
  final List<String> transactionData;
  final List<Oidc4vpTransaction> transactions;

  Future<void> prepare() async {
    for (final element in transactions) {
      await element.prepare();
    }
  }

  Future<void> execute() async {
    for (final element in transactions) {
      await element.execute();
    }
  }

  Future<void> cancel() async {
    for (final element in transactions) {
      await element.cancel();
    }
  }
}
