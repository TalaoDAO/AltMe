import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:trusted_list/trusted_list.dart';

import '../helpers/helpers.dart';
import 'support/reader_test_pki.dart' as pki;

const _noTrustAnchor =
    'certificate chain validation failed: IACA certificate error: no valid '
    'trust anchor found';
const _digestMismatch =
    'issuer authentication failed: a disclosed element does not match its '
    'digest in the MSO';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockProfileModel extends Mock implements ProfileModel {}

class _FakeProfileState extends Fake implements ProfileState {
  _FakeProfileState(this.model);

  @override
  final ProfileModel model;
}

void main() {
  late _MockProfileCubit profileCubit;
  late _MockLangCubit langCubit;
  late _MockProfileModel profileModel;

  setUp(() {
    profileModel = _MockProfileModel();
    when(() => profileModel.trustedList).thenReturn(null);
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
    profileCubit = _MockProfileCubit();
    when(() => profileCubit.state).thenReturn(_FakeProfileState(profileModel));
    langCubit = _MockLangCubit();
    when(() => langCubit.state).thenReturn(
      const LangState(locale: Locale('en'), languageType: LanguageType.phone),
    );
  });

  const trusted = ReaderDocument(
    docType: 'org.iso.18013.5.1.mDL',
    nameSpaces: {
      'org.iso.18013.5.1': {'family_name': 'DOE'},
    },
  );
  const untrusted = ReaderDocument(
    docType: eudiPidDocType,
    nameSpaces: {
      eudiPidDocType: {'family_name': 'ROE'},
    },
    issuerTrustErrors: [_noTrustAnchor],
  );

  Future<void> pump(
    WidgetTester tester,
    ReaderResult result, {
    IssuerMetadataFetcher? fetchIssuerMetadata,
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<LangCubit>.value(value: langCubit),
        ],
        child: Scaffold(
          body: MdocReaderResultView(
            result: result,
            fetchIssuerMetadata:
                fetchIssuerMetadata ?? (url) async => throw Exception('none'),
          ),
        ),
      ),
    );
  }

  group('MdocReaderResultView', () {
    testWidgets('shows a document of a trusted issuer as verified', (
      tester,
    ) async {
      await pump(tester, const ReaderResult(documents: [trusted]));

      expect(find.text('Trusted issuer'), findsOneWidget);
      expect(find.text('Issuer not verified'), findsNothing);
      expect(
        find.text('Issuer and device signatures verified'),
        findsOneWidget,
      );
      expect(find.textContaining('DOE'), findsOneWidget);
      expect(find.text('Not verified'), findsNothing);
    });

    testWidgets('shows a document of an untrusted issuer with its elements '
        'and marks the issuer as not trusted', (tester) async {
      await pump(tester, const ReaderResult(documents: [untrusted]));

      expect(find.text('Issuer not verified'), findsOneWidget);
      expect(
        find.text('The identity of this issuer could not be verified.'),
        findsOneWidget,
      );
      expect(find.text('Trusted issuer'), findsNothing);
      expect(find.text(_noTrustAnchor), findsOneWidget);
      expect(find.textContaining('ROE'), findsOneWidget);
      // The document was read: it is not among those that failed.
      expect(find.text('Not verified'), findsNothing);
    });

    testWidgets('marks each document by its own issuer', (tester) async {
      await pump(tester, const ReaderResult(documents: [trusted, untrusted]));

      expect(find.text('Trusted issuer'), findsOneWidget);
      expect(find.text('Issuer not verified'), findsOneWidget);
      expect(find.textContaining('DOE'), findsOneWidget);
      expect(find.textContaining('ROE'), findsOneWidget);
    });

    testWidgets('still lists a failed document under not verified', (
      tester,
    ) async {
      await pump(
        tester,
        const ReaderResult(
          documents: [untrusted],
          failedDocTypes: ['org.iso.18013.5.1.mDL'],
          documentErrors: {
            'org.iso.18013.5.1.mDL': [_digestMismatch],
          },
        ),
      );

      expect(find.text('Not verified'), findsOneWidget);
      expect(find.text('org.iso.18013.5.1.mDL'), findsOneWidget);
      expect(find.text(_digestMismatch), findsOneWidget);
      expect(find.text('Issuer not verified'), findsOneWidget);
    });

    testWidgets('shows a document as the presentation screens do: its card, '
        'then its elements labelled', (tester) async {
      await pump(tester, const ReaderResult(documents: [trusted]));

      expect(find.byType(CredentialShareCard), findsOneWidget);
      expect(find.byType(CredentialDisplay), findsOneWidget);
      expect(find.text('mDL'), findsOneWidget);
      expect(find.textContaining('Family Name'), findsOneWidget);
    });

    testWidgets('shows a portrait on the card, not again among the elements', (
      tester,
    ) async {
      await pump(
        tester,
        ReaderResult(
          documents: [
            ReaderDocument(
              docType: 'org.iso.18013.5.1.mDL',
              nameSpaces: {
                'org.iso.18013.5.1': {'family_name': 'DOE', 'portrait': _png},
              },
            ),
          ],
        ),
      );

      expect(find.textContaining('DOE'), findsOneWidget);
      expect(find.textContaining('Portrait'), findsNothing);
    });

    group('issuer', () {
      // Signed by an IACA whose chain fails the ISO/IEC 18013-5 profile.
      final signedDocument = ReaderDocument(
        docType: 'org.iso.18013.5.1.mDL',
        nameSpaces: const {
          'org.iso.18013.5.1': {'family_name': 'DOE'},
        },
        issuerTrustErrors: const [_noCrlDistributionPoint],
        issuerCertificateChain: [base64.decode(pki.testDs)],
      );

      void listIaca() => when(() => profileModel.trustedList).thenReturn(
        TrustedList(
          ecosystem: 'test',
          lastUpdated: '2026-10-27',
          entities: [
            TrustedEntity(
              id: 'https://hub.example/',
              type: TrustedEntityType.issuer,
              rootCertificates: const [pki.testIaca],
              vcTypes: const ['org.iso.18013.5.1.mDL'],
            ),
          ],
        ),
      );

      testWidgets('is trusted when the trusted list vouches for it, '
          'whatever the certificate profile says', (tester) async {
        listIaca();
        await pump(tester, ReaderResult(documents: [signedDocument]));

        expect(find.text('Trusted issuer'), findsOneWidget);
        expect(find.text('Issuer not verified'), findsNothing);
        expect(find.text(_noCrlDistributionPoint), findsNothing);
      });

      testWidgets('shows the logo and name of its metadata before the badge', (
        tester,
      ) async {
        listIaca();
        await mockNetworkImagesFor(() async {
          await pump(
            tester,
            ReaderResult(documents: [signedDocument]),
            fetchIssuerMetadata: (url) async =>
                OpenIdConfiguration.fromJson(const {
                  'credential_issuer': 'https://issuer.example/mdl',
                  'display': [
                    {
                      'name': 'Example Issuer',
                      'logo': {'uri': 'https://issuer.example/logo.png'},
                    },
                  ],
                }),
          );
          await tester.pump();

          final logo = tester.widget<CachedImageFromNetwork>(
            find.byType(CachedImageFromNetwork),
          );
          expect(logo.url, 'https://issuer.example/logo.png');
          expect(find.text('Example Issuer'), findsOneWidget);
          expect(
            tester.getTopLeft(find.byType(CachedImageFromNetwork)).dy,
            lessThan(tester.getTopLeft(find.byType(TrustBadge)).dy),
          );
        });
      });

      testWidgets('shows the card and the element names of the credential '
          'configuration of its document type', (tester) async {
        listIaca();
        await pump(
          tester,
          ReaderResult(documents: [signedDocument]),
          // Decoded, as metadata from the network: untyped lists and maps.
          fetchIssuerMetadata: (url) async => OpenIdConfiguration.fromJson(
            _decoded(const {
              'credential_issuer': 'https://issuer.example/mdl',
              'credential_configurations_supported': {
                'mdl': {
                  'format': 'mso_mdoc',
                  'doctype': 'org.iso.18013.5.1.mDL',
                  'credential_metadata': {
                    'display': [
                      {'name': 'Permis de conduire', 'locale': 'fr'},
                      {'name': 'Driving licence', 'locale': 'en'},
                    ],
                    'claims': [
                      {
                        'path': ['org.iso.18013.5.1', 'family_name'],
                        'display': [
                          {'name': 'Nom', 'locale': 'fr'},
                          {'name': 'Surname', 'locale': 'en'},
                        ],
                      },
                    ],
                  },
                },
              },
            }),
          ),
        );
        await tester.pump();

        expect(find.text('Driving licence'), findsOneWidget);
        expect(find.text('mDL'), findsNothing);
        expect(find.textContaining('Surname'), findsOneWidget);
        expect(find.textContaining('Family Name'), findsNothing);
      });

      testWidgets('shows no logo when no metadata is found', (tester) async {
        await pump(tester, ReaderResult(documents: [signedDocument]));
        await tester.pump();

        expect(find.byType(CachedImageFromNetwork), findsNothing);
        expect(find.text('Issuer not verified'), findsOneWidget);
        expect(find.text(_noCrlDistributionPoint), findsOneWidget);
      });
    });
  });
}

Map<String, dynamic> _decoded(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

// A PNG signature followed by padding: enough to be taken for an image.
final _png = <int>[0x89, 0x50, 0x4e, 0x47, ...List.filled(16, 0)];

const _noCrlDistributionPoint =
    'certificate chain validation failed: IACA certificate error: '
    'CrlDistributionPoints: required extension not found';
