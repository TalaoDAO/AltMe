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
import 'package:altme/oidc4vp_transaction/qes_approval/qes_approval_card.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../golden_test_config.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockScanCubit extends MockCubit<ScanState> implements ScanCubit {}

class _MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class _MockProfileModel extends Mock implements ProfileModel {}

class _FakeProfileState extends Fake implements ProfileState {
  _FakeProfileState(this.model);

  @override
  final ProfileModel model;

  @override
  AppStatus get status => AppStatus.idle;
}

String _encode(Map<String, dynamic> part) =>
    base64Url.encode(utf8.encode(jsonEncode(part))).replaceAll('=', '');

/// The QES approval request openid4vc-hub.com/verifier/haip-verifier-2 sent
/// on 2026-10-30, exactly as its request object carried it.
const _sandboxQesApproval =
    'eyJ0eXBlIjoiaHR0cHM6Ly9jbG91ZHNpZ25hdHVyZWNvbnNvcnRpdW0ub3JnLzIwMjUvcWVz'
    'LWFwcHJvdmFsIiwibG9jYXRpb25zIjpbImh0dHBzOi8vaXN0ZWMud2FsdGlkcHJlLmFjY3Yu'
    'ZXMvY3NjL3YyIl0sImRvY3VtZW50SW5mb3MiOlt7Imhhc2giOiJzVE9nd09tKzQ3NGdGajBx'
    'MHgxaVNOc3BLcWJjc2U0SWVpcWxEZy9IV3VJPSIsImxhYmVsIjoiRG9jdW1lbnRvIGRlIHBy'
    'dWViYSIsImhhc2hUeXBlIjoiZHRic3IifV0sIm51bVNpZ25hdHVyZXMiOjEsImNyZWRlbnRp'
    'YWxfaWRzIjpbInFlc19hdHRlc3RhdGlvbiJdLCJoYXNoQWxnb3JpdGhtT0lEIjoiMi4xNi44'
    'NDAuMS4xMDEuMy40LjIuMSIsInNpZ25hdHVyZVF1YWxpZmllciI6ImV1X2VpZGFzX3FlcyIs'
    'InRyYW5zYWN0aW9uX2RhdGFfaGFzaGVzX2FsZyI6WyJzaGEtMjU2Il19';

/// The request object of haip-verifier-2's document signature test: its
/// DCQL query and transaction_data, unsigned.
String _qesRequestObject() =>
    '${_encode(const {'alg': 'ES256', 'typ': 'oauth-authz-req+jwt'})}.'
    '${_encode({
      'client_id': 'x509_hash:SGQeavcGgNWYdvv_fQX-Dtw7ABBU-0hbbpqYdP7F744',
      'response_type': 'vp_token',
      'response_mode': 'direct_post.jwt',
      'response_uri': 'https://openid4vc-hub.com/verifier/haip-verifier-2/response/x',
      'nonce': 'n-0S6_WzA2Mj',
      'dcql_query': {
        'credentials': [
          {
            'id': 'qes_attestation',
            'format': 'dc+sd-jwt',
            'meta': {
              'vct_values': ['https://openid4vc-hub.com/credentials/qtsp-service-user'],
            },
            'claims': [
              {
                'path': ['credentialID'],
              },
              {
                'path': ['userName'],
              },
              {
                'path': ['signatureQualifier'],
              },
              {
                'path': ['certificateFingerprint'],
              },
            ],
            'require_cryptographic_holder_binding': true,
          },
        ],
      },
      'transaction_data': [_sandboxQesApproval],
    })}.c2lnbmF0dXJl';

/// The sandbox QES attestation, as the wallet stores it, with a synthetic
/// SD-JWT carrying the four disclosures the verifier asks for.
CredentialModel _qesAttestation() => CredentialModel.fromJson(
  jsonDecode(
        File(
          'test/dashboard/home/tab_bar/credentials/present/pick/dcql_query/'
          'fixtures/qes_attestation.json',
        ).readAsStringSync(),
      )
      as Map<String, dynamic>,
);

void main() {
  setUpAll(loadAppFonts);

  group('DcqlQueryOfferPickView with a QES approval request', () {
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
      when(() => credentialsCubit.state).thenReturn(
        CredentialsState(
          status: CredentialsStatus.idle,
          credentials: [_qesAttestation()],
        ),
      );

      langCubit = _MockLangCubit();
      when(() => langCubit.state).thenReturn(
        const LangState(locale: Locale('en'), languageType: LanguageType.phone),
      );
    });

    Widget buildSubject() {
      final requestObject = CredentialModel(
        id: 'id',
        image: 'image',
        credentialPreview: Credential.dummy(),
        shareLink: 'shareLink',
        data: const {},
        jwt: _qesRequestObject(),
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
            credential: requestObject,
            issuer: Issuer.emptyIssuer('openid4vc-hub.com'),
            inputDescriptorIndex: 0,
            credentialsToBePresented: const [],
          ),
        ),
      );
    }

    for (final device in phoneScreenSizes) {
      testWidgets('shows the signature request on ${device.name}', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(device.size);
        tester.view.devicePixelRatio = device.devicePixelRatio;
        addTearDown(() async {
          tester.view.resetDevicePixelRatio();
          await tester.binding.setSurfaceSize(null);
        });

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.byType(QesApprovalCard), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is MyElevatedButton && widget.text == 'Sign',
          ),
          findsOneWidget,
        );

        await expectLater(
          find.byType(DcqlQueryOfferPickView),
          matchesGoldenFile(
            'goldens/qes_consent_screen/qes_consent_screen_${device.name}.png',
          ),
        );
      });
    }
  });
}
