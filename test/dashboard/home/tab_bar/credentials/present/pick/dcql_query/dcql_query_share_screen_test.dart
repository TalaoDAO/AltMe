import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/dcql_query/dcql_query_pick_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/oidc4vc/helper_function/mdoc_credential_data.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

import '../../../../../../../golden_test_config.dart';
import '../../../../../../../oidc4vc/support/issuer_signed_fixture.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockScanCubit extends MockCubit<ScanState> implements ScanCubit {}

class _MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class _MockProfileModel extends Mock implements ProfileModel {}

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

class _FakeProfileState extends Fake implements ProfileState {
  _FakeProfileState(this.model);

  @override
  final ProfileModel model;

  @override
  AppStatus get status => AppStatus.idle;
}

String _encode(Map<String, dynamic> part) =>
    base64Url.encode(utf8.encode(jsonEncode(part))).replaceAll('=', '');

/// A request object asking for [credentialQuery], unsigned and without
/// transaction_data.
CredentialModel _requestObject(
  Map<String, dynamic> credentialQuery,
) => CredentialModel(
  id: 'request',
  image: 'image',
  credentialPreview: Credential.dummy(),
  shareLink: 'shareLink',
  data: const {},
  jwt:
      '${_encode(const {'alg': 'ES256', 'typ': 'oauth-authz-req+jwt'})}.'
      '${_encode({
        'client_id': 'x509_hash:SGQeavcGgNWYdvv_fQX-Dtw7ABBU-0hbbpqYdP7F744',
        'response_type': 'vp_token',
        'response_mode': 'direct_post',
        'response_uri': 'https://verifier.example/response',
        'nonce': 'n-0S6_WzA2Mj',
        'dcql_query': {
          'credentials': [credentialQuery],
        },
      })}.c2lnbmF0dXJl',
);

const _sdJwtQuery = {
  'id': 'qes_attestation',
  'format': 'dc+sd-jwt',
  'meta': {
    'vct_values': ['https://openid4vc-hub.com/credentials/qtsp-service-user'],
  },
  'claims': [
    {
      'path': ['userName'],
    },
    {
      'path': ['credentialID'],
    },
  ],
};

const _mdocQuery = {
  'id': 'mdl',
  'format': 'mso_mdoc',
  'meta': {'doctype_value': mdlDocType},
  'claims': [
    {
      'path': [mdlNameSpace, 'family_name'],
    },
    {
      'path': [mdlNameSpace, 'age_over_18'],
    },
  ],
};

CredentialModel _qesAttestation({String? id}) {
  final credential = CredentialModel.fromJson(
    jsonDecode(
          File(
            'test/dashboard/home/tab_bar/credentials/present/pick/dcql_query/'
            'fixtures/qes_attestation.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>,
  );
  return id == null ? credential : credential.copyWith(id: id);
}

/// A 1×1 PNG.
final _png = base64.decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4z8DwHwAFAAH/'
  'iZk9HQAAAABJRU5ErkJggg==',
);

Future<CredentialModel> _mdl({Map<String, Object?>? elements}) async {
  final data = await getMdocCredentialData(
    issuerSigned: elements == null
        ? testIssuerSigned()
        : testIssuerSigned(elements: elements),
    credentialType: 'mDL',
    platformKeys: _MockPlatformP256Keys(),
  );
  return CredentialModel(
    id: 'mdl',
    image: '',
    shareLink: '',
    data: data,
    credentialPreview: Credential.dummy(),
    format: 'mso_mdoc',
    keyId: 'mdoc_1',
  );
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    registerFallbackValue(_FakeProfileState(_MockProfileModel()));
  });

  group('DcqlQueryOfferPickView share screen', () {
    late _MockProfileCubit profileCubit;
    late _MockCredentialsCubit credentialsCubit;
    late _MockLangCubit langCubit;

    setUp(() {
      final profileModel = _MockProfileModel();
      when(() => profileModel.profileSetting).thenReturn(
        ProfileSetting(
          walletSecurityOptions: WalletSecurityOptions.initial(),
          selfSovereignIdentityOptions: SelfSovereignIdentityOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          settingsMenu: SettingsMenu.initial(),
          version: '1.0.0',
        ),
      );
      when(() => profileModel.isDeveloperMode).thenReturn(false);
      when(() => profileModel.profileType).thenReturn(ProfileType.defaultOne);
      profileCubit = _MockProfileCubit();
      when(
        () => profileCubit.state,
      ).thenReturn(_FakeProfileState(profileModel));
      credentialsCubit = _MockCredentialsCubit();
      langCubit = _MockLangCubit();
      when(() => langCubit.state).thenReturn(
        const LangState(locale: Locale('en'), languageType: LanguageType.phone),
      );
    });

    Widget buildSubject({
      required Map<String, dynamic> query,
      required List<CredentialModel> stored,
    }) {
      when(() => credentialsCubit.state).thenReturn(
        CredentialsState(status: CredentialsStatus.idle, credentials: stored),
      );
      return MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<CredentialsCubit>.value(value: credentialsCubit),
          BlocProvider<LangCubit>.value(value: langCubit),
          BlocProvider<ScanCubit>.value(value: _MockScanCubit()),
          BlocProvider<QRCodeScanCubit>.value(value: _MockQRCodeScanCubit()),
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
          home: DcqlQueryOfferPickView(
            uri: Uri.parse('openid4vp://authorize'),
            credential: _requestObject(query),
            issuer: Issuer.emptyIssuer('verifier.example'),
            inputDescriptorIndex: 0,
            credentialsToBePresented: const [],
          ),
        ),
      );
    }

    Future<void> pump(WidgetTester tester, Widget subject) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();
    }

    testWidgets('titles the screen, labels the shared data and offers Share', (
      tester,
    ) async {
      await pump(
        tester,
        buildSubject(query: _sdJwtQuery, stored: [_qesAttestation()]),
      );

      expect(find.text('Review the request'), findsOneWidget);
      expect(find.text('Data shared from this attestation'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is MyElevatedButton && widget.text == 'Share',
        ),
        findsOneWidget,
      );
    });

    testWidgets('lists only the labels of the requested data, folded', (
      tester,
    ) async {
      await pump(
        tester,
        buildSubject(query: _sdJwtQuery, stored: [_qesAttestation()]),
      );

      expect(find.text('QTSP user identifier'), findsOneWidget);
      expect(find.text('Signing credential identifier'), findsOneWidget);
      // Not asked for, so not listed.
      expect(find.text('Signaturequalifier'), findsNothing);
      // Folded: no value.
      expect(find.text('C_1235'), findsNothing);
      expect(find.text('DF6757874'), findsNothing);
    });

    testWidgets(
      'a tap unfolds the value of one row and a second tap folds it',
      (tester) async {
        await pump(
          tester,
          buildSubject(query: _sdJwtQuery, stored: [_qesAttestation()]),
        );

        await tester.tap(find.text('QTSP user identifier'));
        await tester.pumpAndSettle();
        expect(find.text('C_1235'), findsOneWidget);
        expect(find.text('DF6757874'), findsNothing);

        await tester.tap(find.text('QTSP user identifier'));
        await tester.pumpAndSettle();
        expect(find.text('C_1235'), findsNothing);
      },
    );

    testWidgets('a row is operable by a screen reader', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        buildSubject(query: _sdJwtQuery, stored: [_qesAttestation()]),
      );

      SemanticsData row() => tester
          .getSemantics(find.text('QTSP user identifier'))
          .getSemanticsData();

      // The row is a tappable control that says whether it is unfolded.
      expect(row().hasAction(SemanticsAction.tap), isTrue);
      expect(row().hint, 'Collapsed');

      await tester.tap(find.text('QTSP user identifier'));
      await tester.pumpAndSettle();
      expect(row().hint, 'Expanded');
      handle.dispose();
    });

    testWidgets('an mdoc shows the same labels and layout as an SD-JWT', (
      tester,
    ) async {
      await pump(
        tester,
        buildSubject(query: _mdocQuery, stored: [await _mdl()]),
      );

      expect(find.text('Review the request'), findsOneWidget);
      expect(find.text('Data shared from this attestation'), findsOneWidget);
      // One folded row per requested claim, none with its value.
      expect(find.byType(ExpansionTile), findsNWidgets(2));
      // No display in the metadata: the element's own name, readable.
      expect(find.text('Family Name'), findsOneWidget);
      expect(find.text('Age Over 18'), findsOneWidget);
      expect(find.text('Doe'), findsNothing);

      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();
      expect(find.text('Doe'), findsOneWidget);
    });

    testWidgets('unfolds an image claim as a picture, not its data: URI', (
      tester,
    ) async {
      await pump(
        tester,
        buildSubject(
          query: const {
            'id': 'mdl',
            'format': 'mso_mdoc',
            'meta': {'doctype_value': mdlDocType},
            'claims': [
              {
                'path': [mdlNameSpace, 'portrait'],
              },
            ],
          },
          stored: [
            await _mdl(elements: {'family_name': 'Doe', 'portrait': _png}),
          ],
        ),
      );

      await tester.tap(find.text('Portrait'));
      await tester.pumpAndSettle();

      final row = find.byType(ExpansionTile);
      expect(
        find.descendant(of: row, matching: find.byType(Image)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: row,
          matching: find.textContaining('data:image', findRichText: true),
        ),
        findsNothing,
      );
    });

    testWidgets('puts the radio under the card, at the end, with several '
        'candidates', (tester) async {
      await pump(
        tester,
        buildSubject(
          query: _sdJwtQuery,
          stored: [
            _qesAttestation(id: 'a'),
            _qesAttestation(id: 'b'),
          ],
        ),
      );

      final radios = find.byWidgetPredicate(
        (widget) =>
            widget is Icon &&
            (widget.icon == Icons.radio_button_checked ||
                widget.icon == Icons.radio_button_off),
      );
      expect(radios, findsNWidgets(2));
      // The first match is picked.
      expect(
        tester.widget<Icon>(radios.first).icon,
        Icons.radio_button_checked,
      );
      expect(tester.widget<Icon>(radios.last).icon, Icons.radio_button_off);

      final card = find.byType(Card).first;
      final image = find.byType(CredentialCardImage).first;
      final radio = tester.getRect(radios.first);
      // Under the picture, not beside it, and at the end of the card.
      expect(radio.top, greaterThanOrEqualTo(tester.getRect(image).bottom));
      expect(tester.getRect(card).right - radio.right, lessThan(24));

      await tester.tap(radios.last);
      await tester.pumpAndSettle();
      expect(tester.widget<Icon>(radios.last).icon, Icons.radio_button_checked);

      // A tap on a card's picture picks it too.
      await tester.tap(image);
      await tester.pumpAndSettle();
      expect(
        tester.widget<Icon>(radios.first).icon,
        Icons.radio_button_checked,
      );
      expect(tester.widget<Icon>(radios.last).icon, Icons.radio_button_off);

      // Anywhere on the card picks it, e.g. the label above its data...
      final secondCardLabel = find.text('Data shared from this attestation');
      await tester.ensureVisible(secondCardLabel.last);
      await tester.tap(secondCardLabel.last);
      await tester.pumpAndSettle();
      expect(tester.widget<Icon>(radios.last).icon, Icons.radio_button_checked);

      // ...but a data row only unfolds.
      await tester.ensureVisible(find.byType(ExpansionTile).first);
      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();
      expect(tester.widget<Icon>(radios.last).icon, Icons.radio_button_checked);
    });

    testWidgets('has no radio with a single candidate', (tester) async {
      await pump(
        tester,
        buildSubject(query: _sdJwtQuery, stored: [_qesAttestation()]),
      );

      expect(find.byIcon(Icons.radio_button_checked), findsNothing);
      expect(find.byIcon(Icons.radio_button_off), findsNothing);
    });

    for (final (name, query, stored) in [
      ('sd_jwt', _sdJwtQuery, () async => _qesAttestation()),
      ('mdoc', _mdocQuery, _mdl),
    ]) {
      testWidgets('golden: $name, folded and with one row unfolded', (
        tester,
      ) async {
        await pump(
          tester,
          buildSubject(query: query, stored: [await stored()]),
        );

        await expectLater(
          find.byType(DcqlQueryOfferPickView),
          matchesGoldenFile('goldens/share_screen/${name}_folded.png'),
        );

        await tester.tap(find.byType(ExpansionTile).first);
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(DcqlQueryOfferPickView),
          matchesGoldenFile('goldens/share_screen/${name}_unfolded.png'),
        );
      });
    }
  });
}
