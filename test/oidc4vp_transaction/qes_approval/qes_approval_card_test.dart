import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/qes_approval/qes_approval_card.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

import '../../golden_test_config.dart';

Finder _text(String text) => find.textContaining(text, findRichText: true);

/// The sandbox document signature request of 2026-10-30.
const _sandboxRequest = QesApprovalRequest(
  documentInfos: [
    QesDocumentInfo(label: 'Documento de prueba', hash: 'aGFzaA=='),
  ],
  locations: ['https://istec.waltidpre.accv.es/csc/v2'],
  numSignatures: 1,
  signatureQualifier: 'eu_eidas_qes',
);

/// Several documents, a level the wallet doesn't translate, no signing
/// service and no number of signatures.
const _sealRequest = QesApprovalRequest(
  documentInfos: [
    QesDocumentInfo(label: 'Example Contract', hash: 'aGFzaA=='),
    QesDocumentInfo(label: 'Example Terms of Service', hash: 'aGFzaA=='),
    QesDocumentInfo(label: 'Example Invoice', hash: 'aGFzaA=='),
  ],
  signatureQualifier: 'eu_eidas_qeseal',
);

void main() {
  setUpAll(loadAppFonts);

  /// Pumps the card alone on a phone-sized surface, in the app's theme.
  Future<void> pumpCard(WidgetTester tester, QesApprovalRequest request) async {
    await tester.binding.setSurfaceSize(const Size(390, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.seedThemeData(Brightness.dark, null),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: QesApprovalCard(request: request),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('QesApprovalCard', () {
    testWidgets('shows what the user approves', (tester) async {
      await pumpCard(tester, _sandboxRequest);

      expect(_text('Signature request'), findsOneWidget);
      expect(_text('Documento de prueba'), findsOneWidget);
      expect(_text('Qualified electronic signature (eIDAS)'), findsOneWidget);
      expect(_text('istec.waltidpre.accv.es'), findsOneWidget);
      expect(_text('By signing, you authorise'), findsOneWidget);

      await expectLater(
        find.byType(QesApprovalCard),
        matchesGoldenFile('goldens/qes_approval_card_sandbox.png'),
      );
    });

    testWidgets('lists every document and an unknown level as received', (
      tester,
    ) async {
      await pumpCard(tester, _sealRequest);

      expect(_text('Example Terms of Service'), findsOneWidget);
      expect(_text('eu_eidas_qeseal'), findsOneWidget);
      expect(_text('Signing service'), findsNothing);
      expect(_text('Number of signatures'), findsNothing);

      await expectLater(
        find.byType(QesApprovalCard),
        matchesGoldenFile('goldens/qes_approval_card_several_documents.png'),
      );
    });
  });
}
