import 'package:altme/oidc4vp_transaction/qes_approval/qes_approval_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

import '../../helpers/helpers.dart';

Finder _text(String text) => find.textContaining(text, findRichText: true);

void main() {
  group('QesApprovalCard', () {
    testWidgets('shows what the user approves', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: QesApprovalCard(
            request: QesApprovalRequest(
              documentInfos: [
                QesDocumentInfo(label: 'Documento de prueba', hash: 'aGFzaA=='),
              ],
              locations: ['https://istec.waltidpre.accv.es/csc/v2'],
              numSignatures: 1,
              signatureQualifier: 'eu_eidas_qes',
            ),
          ),
        ),
      );

      expect(_text('Signature request'), findsOneWidget);
      expect(_text('Documento de prueba'), findsOneWidget);
      expect(_text('Qualified electronic signature (eIDAS)'), findsOneWidget);
      expect(_text('istec.waltidpre.accv.es'), findsOneWidget);
      expect(_text('By signing, you authorise'), findsOneWidget);
    });

    testWidgets('shows an unknown signature level as received', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: QesApprovalCard(
            request: QesApprovalRequest(
              documentInfos: [QesDocumentInfo(label: 'Seal', hash: 'aGFzaA==')],
              signatureQualifier: 'eu_eidas_qeseal',
            ),
          ),
        ),
      );

      expect(_text('eu_eidas_qeseal'), findsOneWidget);
      expect(_text('Signing service'), findsNothing);
      expect(_text('Number of signatures'), findsNothing);
    });
  });
}
