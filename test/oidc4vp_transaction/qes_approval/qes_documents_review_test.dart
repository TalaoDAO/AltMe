import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/widgets/white_close_button.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/qes_approval/qes_documents_review.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockProfileModel extends Mock implements ProfileModel {}

class _FakeProfileState extends Fake implements ProfileState {
  _FakeProfileState(this.model);

  @override
  final ProfileModel model;
}

Finder _text(String text) => find.textContaining(text, findRichText: true);

MyElevatedButton _continueButton(WidgetTester tester) =>
    tester.widget<MyElevatedButton>(find.byType(MyElevatedButton));

void main() {
  setUpAll(loadAppFonts);

  Future<void> pumpReview(
    WidgetTester tester,
    List<QesDocumentInfo> documents, {
    VoidCallback? onContinue,
    QesPdfViewBuilder? pdfViewBuilder,
    QesDocumentLoader? loadDocument,
    bool settle = true,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // The please-wait overlay draws the wallet logo.
    final profileModel = _MockProfileModel();
    when(() => profileModel.profileType).thenReturn(ProfileType.defaultOne);
    final profileCubit = _MockProfileCubit();
    when(() => profileCubit.state).thenReturn(_FakeProfileState(profileModel));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<FlavorCubit>.value(
            value: FlavorCubit(FlavorMode.development),
          ),
        ],
        child: MaterialApp(
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
            pdfViewBuilder: pdfViewBuilder,
            loadDocument: loadDocument,
          ),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
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
          href: 'data:image/png;base64,${base64.encode([137, 80, 78, 71])}',
        ),
      ]);

      expect(_text('cannot be shown as text'), findsOneWidget);
    });

    testWidgets('says to wait while the documents load', (tester) async {
      final loading = Completer<QesDocumentContent?>();
      await pumpReview(
        tester,
        const [QesDocumentInfo(label: 'Contract', hash: 'aGFzaA==')],
        loadDocument: (_) => loading.future,
        settle: false,
      );
      await tester.pump();

      expect(_text('Please wait a moment'), findsOneWidget);
      expect(_continueButton(tester).onPressed, isNull);

      loading.complete(null);
      await tester.pumpAndSettle();

      expect(_text('Please wait a moment'), findsNothing);
      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('shows a PDF document in the PDF viewer', (tester) async {
      final pdf = [0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x37];
      List<int>? shown;
      await pumpReview(
        tester,
        [
          QesDocumentInfo(
            label: 'Example Contract',
            hash: 'aGFzaA==',
            href: 'data:application/pdf;base64,${base64.encode(pdf)}',
          ),
        ],
        pdfViewBuilder: (context, bytes) {
          shown = bytes;
          return const Text('pdf viewer');
        },
      );

      expect(_text('pdf viewer'), findsOneWidget);
      expect(shown, pdf);
      expect(_text('cannot be shown as text'), findsNothing);
      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('shows a single PDF full screen with the continue button over '
        'it and the cross to cancel', (tester) async {
      final pdf = [0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x37];
      await pumpReview(
        tester,
        [
          QesDocumentInfo(
            label: 'Example Contract',
            hash: 'aGFzaA==',
            href: 'data:application/pdf;base64,${base64.encode(pdf)}',
            checksum: 'sha256-${base64.encode(sha256.convert(pdf).bytes)}',
          ),
        ],
        pdfViewBuilder: (context, bytes) => const SizedBox.expand(
          child: ColoredBox(color: Colors.white, key: Key('pdf')),
        ),
      );

      final screen = tester.getSize(find.byType(Scaffold));
      final pdfBox = tester.getRect(find.byKey(const Key('pdf')));
      final button = tester.getRect(find.byType(MyElevatedButton));
      expect(pdfBox.width, screen.width);
      expect(pdfBox.bottom, screen.height);
      expect(button.bottom, lessThanOrEqualTo(pdfBox.bottom));
      expect(button.top, greaterThan(pdfBox.top));
      expect(find.byType(WhiteCloseButton), findsOneWidget);
      expect(_text('Example Contract'), findsOneWidget);
      expect(_text('Integrity verified'), findsOneWidget);
    });

    testWidgets('lists several PDF documents with a viewer each', (
      tester,
    ) async {
      final pdf = base64.encode([0x25, 0x50, 0x44, 0x46, 0x2d]);
      await pumpReview(tester, [
        for (final label in ['First', 'Second'])
          QesDocumentInfo(
            label: label,
            hash: 'aGFzaA==',
            href: 'data:application/pdf;base64,$pdf',
          ),
      ], pdfViewBuilder: (context, bytes) => const Text('pdf viewer'));

      expect(_text('pdf viewer'), findsNWidgets(2));
      expect(_text('First'), findsOneWidget);
      expect(_text('Second'), findsOneWidget);
    });
  });
}
