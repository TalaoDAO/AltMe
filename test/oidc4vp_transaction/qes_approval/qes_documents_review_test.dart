import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/qes_approval/qes_documents_review.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

import '../../golden_test_config.dart';

const _contract =
    'Contract between the parties.\n\n'
    '1. The signer agrees to the terms of service.\n'
    '2. This contract is governed by Spanish law.';

String _dataUrl(String text) =>
    'data:text/plain;base64,${base64.encode(utf8.encode(text))}';

String _checksum(String text) =>
    'sha256-${base64.encode(sha256.convert(utf8.encode(text)).bytes)}';

Finder _text(String text) => find.textContaining(text, findRichText: true);

MyElevatedButton _continueButton(WidgetTester tester) =>
    tester.widget<MyElevatedButton>(find.byType(MyElevatedButton));

void main() {
  setUpAll(loadAppFonts);

  Future<void> pumpReview(
    WidgetTester tester,
    List<QesDocumentInfo> documents, {
    VoidCallback? onContinue,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
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
        home: QesDocumentsReview(
          request: QesApprovalRequest(documentInfos: documents),
          onContinue: onContinue ?? () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('QesDocumentsReview', () {
    testWidgets('shows the text to sign, its integrity and the OTP', (
      tester,
    ) async {
      var continued = false;
      await pumpReview(tester, [
        QesDocumentInfo(
          label: 'Example Contract',
          hash: 'aGFzaA==',
          href: _dataUrl(_contract),
          checksum: _checksum(_contract),
          accessType: 'OTP',
          oneTimePassword: '51623',
        ),
      ], onContinue: () => continued = true);

      expect(_text('Example Contract'), findsOneWidget);
      expect(_text('governed by Spanish law'), findsOneWidget);
      expect(_text('Integrity verified'), findsOneWidget);
      expect(_text('51623'), findsOneWidget);
      await expectLater(
        find.byType(QesDocumentsReview),
        matchesGoldenFile('goldens/qes_documents_review_text.png'),
      );

      await tester.tap(find.byType(MyElevatedButton));
      expect(continued, isTrue);
    });

    testWidgets('says when no checksum verified the text', (tester) async {
      await pumpReview(tester, [
        QesDocumentInfo(
          label: 'Example Contract',
          hash: 'aGFzaA==',
          href: _dataUrl(_contract),
        ),
      ]);

      expect(_text('Integrity not verified'), findsOneWidget);
      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('stops the approval when a document fails its checksum', (
      tester,
    ) async {
      await pumpReview(tester, [
        QesDocumentInfo(
          label: 'Example Contract',
          hash: 'aGFzaA==',
          href: _dataUrl('A different contract.'),
          checksum: _checksum(_contract),
        ),
      ]);

      expect(_text('does not match its checksum'), findsOneWidget);
      expect(_text('A different contract.'), findsNothing);
      expect(_continueButton(tester).onPressed, isNull);
      await expectLater(
        find.byType(QesDocumentsReview),
        matchesGoldenFile('goldens/qes_documents_review_checksum_failed.png'),
      );
    });

    testWidgets('says when the verifier gave no content', (tester) async {
      await pumpReview(tester, const [
        QesDocumentInfo(label: 'Documento de prueba', hash: 'aGFzaA=='),
      ]);

      expect(_text('Documento de prueba'), findsOneWidget);
      expect(_text('did not provide the content'), findsOneWidget);
      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('says when a document is not text', (tester) async {
      await pumpReview(tester, [
        QesDocumentInfo(
          label: 'Example Contract',
          hash: 'aGFzaA==',
          href: 'data:application/pdf;base64,${base64.encode([37, 80])}',
        ),
      ]);

      expect(_text('cannot be shown as text'), findsOneWidget);
    });
  });
}
