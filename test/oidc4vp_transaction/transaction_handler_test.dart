import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/qes_approval/qes_approval_card.dart';
import 'package:altme/oidc4vp_transaction/qes_approval/qes_approval_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

import '../helpers/helpers.dart';

String _encode(Map<String, dynamic> json) =>
    base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');

void main() {
  final qesApproval = _encode({
    'type': qesApprovalTransactionType,
    'credential_ids': ['qes_attestation'],
    'documentInfos': [
      {'label': 'Contract', 'hash': 'aGFzaA=='},
    ],
  });

  group('Parameters.transactionHandlers', () {
    const handlers = Parameters.transactionHandlers;

    test('supports QES approvals', () {
      final items = handlers.dataTypes.parse(
        [qesApproval],
        credentialQueryIds: {'qes_attestation'},
      );

      expect(handlers.of(items.single), isA<QesApprovalHandler>());
    });

    test('supports no other type', () {
      expect(
        () => handlers.dataTypes.parse(
          [
            _encode({
              'type': 'evm.erc20_transfer',
              'credential_ids': ['qes_attestation'],
            }),
          ],
          credentialQueryIds: {'qes_attestation'},
        ),
        throwsA(isA<TransactionDataException>()),
      );
    });
  });

  group('QesApprovalHandler', () {
    testWidgets('shows the QES card and offers to sign', (tester) async {
      final item = TransactionDataItem.parse(qesApproval);
      late String label;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            label = const QesApprovalHandler().confirmLabel(context.l10n);
            return Scaffold(
              body: const QesApprovalHandler().buildConsent(context, item),
            );
          },
        ),
      );

      expect(find.byType(QesApprovalCard), findsOneWidget);
      expect(label, 'Sign');
    });
  });
}
