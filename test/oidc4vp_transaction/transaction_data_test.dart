import 'package:altme/oidc4vp_transaction/domain/transaction_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('TransactionData', () {
    test('hashes the exact transaction_data strings', () {
      const entry = 'eyJ0eXBlIjoiZXZtLmVyYzIwX3RyYW5zZmVyIn0';

      final transactionData = TransactionData(
        transactionData: const [entry],
        transactions: const [],
      );

      expect(transactionData.transactionDataHashes, [sh256Hash(entry)]);
      expect(
        transactionData.transactionDataHashes,
        isNot([sh256Hash('"$entry"')]),
      );
    });
  });
}
