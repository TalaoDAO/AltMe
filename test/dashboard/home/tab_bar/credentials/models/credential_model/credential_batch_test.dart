import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_objects.dart';

void main() {
  CredentialModel credential(String id, {String? batchId}) =>
      TEST_CREDENTIAL.copyWith(id: id, batchId: batchId);

  final alone = credential('alone');
  final a1 = credential('a1', batchId: 'batch-a');
  final b1 = credential('b1', batchId: 'batch-b');
  final a2 = credential('a2', batchId: 'batch-a');
  final b2 = credential('b2', batchId: 'batch-b');
  final a3 = credential('a3', batchId: 'batch-a');
  final credentials = [a1, alone, b1, a2, b2, a3];

  group('onePerBatch', () {
    test('keeps the first copy of each batch, in its place', () {
      expect(credentials.onePerBatch.map((c) => c.id), ['a1', 'alone', 'b1']);
    });

    test('keeps every credential issued alone', () {
      final singles = [alone, credential('other')];

      expect(singles.onePerBatch, singles);
    });
  });

  group('copiesOf', () {
    test('lists every copy of the batch', () {
      expect(credentials.copiesOf(a2).map((c) => c.id), ['a1', 'a2', 'a3']);
    });

    test('is the credential itself when it was issued alone', () {
      expect(credentials.copiesOf(alone), [alone]);
    });
  });
}
