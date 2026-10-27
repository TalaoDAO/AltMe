import 'dart:convert';

import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:trusted_list/trusted_list.dart';

import 'support/reader_test_pki.dart';

const _mdl = 'org.iso.18013.5.1.mDL';

ReaderDocument _document({
  List<String> chain = const [testDs],
  List<String> issuerTrustErrors = const ['CrlDistributionPoints: missing'],
}) => ReaderDocument(
  docType: _mdl,
  nameSpaces: const {
    'org.iso.18013.5.1': {'family_name': 'DOE'},
  },
  issuerTrustErrors: issuerTrustErrors,
  issuerCertificateChain: [for (final der in chain) base64.decode(der)],
);

TrustedList _trustedList({
  TrustedEntityType type = TrustedEntityType.issuer,
  List<String> vcTypes = const [_mdl],
}) => TrustedList(
  ecosystem: 'test',
  lastUpdated: '2026-10-27',
  entities: [
    TrustedEntity(
      id: 'https://hub.example/',
      type: type,
      name: 'Test mdoc IACA',
      rootCertificates: const [testIaca],
      vcTypes: vcTypes,
    ),
  ],
);

void main() {
  group('readerTrustedIssuer', () {
    test('is the issuer entry whose root issued the document signer', () {
      final entity = readerTrustedIssuer(
        trustedList: _trustedList(),
        document: _document(),
      );
      expect(entity?.id, 'https://hub.example/');
    });

    test('is null for a signer no listed root issued', () {
      expect(
        readerTrustedIssuer(
          trustedList: _trustedList(),
          document: _document(chain: [rogueDs]),
        ),
        isNull,
      );
    });

    test('does not let a root appended to the chain vouch for the signer', () {
      expect(
        readerTrustedIssuer(
          trustedList: _trustedList(),
          document: _document(chain: [rogueDs, testDs, testIaca]),
        ),
        isNull,
      );
    });

    test('is null for an entry not registered for the document type', () {
      expect(
        readerTrustedIssuer(
          trustedList: _trustedList(vcTypes: ['eu.europa.ec.eudi.pid.1']),
          document: _document(),
        ),
        isNull,
      );
    });

    test('is null for an entry that is not an issuer', () {
      expect(
        readerTrustedIssuer(
          trustedList: _trustedList(type: TrustedEntityType.verifier),
          document: _document(),
        ),
        isNull,
      );
    });

    test('is null without a trusted list or a chain', () {
      expect(
        readerTrustedIssuer(trustedList: null, document: _document()),
        isNull,
      );
      expect(
        readerTrustedIssuer(
          trustedList: _trustedList(),
          document: _document(chain: []),
        ),
        isNull,
      );
    });
  });

  group('readerIssuerUrls', () {
    test("lists the signer's alternative names, then the trusted entry", () {
      final document = _document();
      expect(
        readerIssuerUrls(
          document: document,
          trustedIssuer: readerTrustedIssuer(
            trustedList: _trustedList(),
            document: document,
          ),
        ),
        [
          'https://issuer.example/mdl',
          'https://issuer.example',
          'https://hub.example',
        ],
      );
    });

    test("tries the trusted entry's endpoint before its identifier", () {
      final document = _document(chain: [rogueDs]);
      expect(
        readerIssuerUrls(
          document: document,
          trustedIssuer: TrustedEntity(
            id: 'https://hub.example/',
            type: TrustedEntityType.issuer,
            rootCertificates: const [testIaca],
            vcTypes: const [_mdl],
            endpoint: 'https://hub.example/issuer/core-mdl-issuer',
          ),
        ),
        ['https://hub.example/issuer/core-mdl-issuer', 'https://hub.example'],
      );
    });

    test('is empty for a signer without names and no trusted entry', () {
      expect(readerIssuerUrls(document: _document(chain: [rogueDs])), isEmpty);
    });
  });

  group('readerCredentialConfigurationId', () {
    OpenIdConfiguration metadata(Object? configurations) =>
        OpenIdConfiguration.fromJson({
          'credential_issuer': 'https://issuer.example',
          'credential_configurations_supported': configurations,
        });

    test('is the configuration issuing the document type', () {
      expect(
        readerCredentialConfigurationId(
          metadata({
            'pid': {'format': 'mso_mdoc', 'doctype': 'eu.europa.ec.eudi.pid.1'},
            'mdl': {'format': 'mso_mdoc', 'doctype': _mdl},
          }),
          _mdl,
        ),
        'mdl',
      );
    });

    test('is null when no configuration issues the document type', () {
      expect(
        readerCredentialConfigurationId(
          metadata({
            'pid': {'format': 'dc+sd-jwt', 'vct': 'urn:eudi:pid:1'},
          }),
          _mdl,
        ),
        isNull,
      );
      expect(readerCredentialConfigurationId(metadata(null), _mdl), isNull);
    });
  });

  group('ReaderIssuerCubit', () {
    ReaderIssuerCubit cubit({
      TrustedList? trustedList,
      ReaderDocument? document,
      IssuerMetadataFetcher? fetch,
    }) => ReaderIssuerCubit(
      document: document ?? _document(),
      trustedList: trustedList,
      fetchIssuerMetadata:
          fetch ?? (url) async => throw Exception('no metadata at $url'),
      languageCode: 'en',
    );

    test('trusts an issuer the trusted list vouches for, even when the '
        'ISO/IEC 18013-5 profile fails', () {
      expect(cubit(trustedList: _trustedList()).state.isTrusted, isTrue);
    });

    test('trusts an issuer that passed the ISO/IEC 18013-5 checks', () {
      expect(
        cubit(document: _document(issuerTrustErrors: [])).state.isTrusted,
        isTrue,
      );
    });

    test('does not trust an issuer neither check vouches for', () {
      expect(
        cubit(
          trustedList: _trustedList(),
          document: _document(chain: [rogueDs]),
        ).state.isTrusted,
        isFalse,
      );
    });

    test(
      'takes the name and logo from the first URL serving metadata',
      () async {
        final asked = <String>[];
        final issuerCubit = cubit(
          trustedList: _trustedList(),
          fetch: (url) async {
            asked.add(url);
            if (url != 'https://issuer.example') throw Exception('404');
            return OpenIdConfiguration.fromJson(const {
              'credential_issuer': 'https://issuer.example',
              'display': [
                {
                  'name': 'Example Issuer',
                  'locale': 'en',
                  'logo': {'uri': 'https://issuer.example/logo.png'},
                },
              ],
            });
          },
        );

        await issuerCubit.resolveDisplay();

        expect(asked, ['https://issuer.example/mdl', 'https://issuer.example']);
        expect(
          issuerCubit.state,
          const ReaderIssuerState(
            isTrusted: true,
            name: 'Example Issuer',
            logoUri: 'https://issuer.example/logo.png',
          ),
        );
      },
    );

    test('takes the card and the element names from the credential '
        'configuration of the document type', () async {
      const configuration = {
        'format': 'mso_mdoc',
        'doctype': _mdl,
        'credential_metadata': {
          'display': [
            {'name': 'Driving licence', 'locale': 'en'},
          ],
          'claims': [
            {
              'path': ['org.iso.18013.5.1', 'family_name'],
              'display': [
                {'name': 'Surname', 'locale': 'en'},
              ],
            },
          ],
        },
      };
      final issuerCubit = cubit(
        trustedList: _trustedList(),
        fetch: (url) async => OpenIdConfiguration.fromJson(const {
          'credential_issuer': 'https://issuer.example',
          'credential_configurations_supported': {'mdl': configuration},
        }),
      );

      await issuerCubit.resolveDisplay();

      expect(issuerCubit.state.credentialDisplay?.name, 'Driving licence');
      expect(issuerCubit.state.credentialSupported, configuration);
    });

    test('keeps the default card when the metadata does not issue the '
        'document type', () async {
      final issuerCubit = cubit(
        trustedList: _trustedList(),
        fetch: (url) async => OpenIdConfiguration.fromJson(const {
          'credential_issuer': 'https://issuer.example',
          'display': [
            {'name': 'Example Issuer', 'locale': 'en'},
          ],
          'credential_configurations_supported': {
            'pid': {'format': 'mso_mdoc', 'doctype': 'eu.europa.ec.eudi.pid.1'},
          },
        }),
      );

      await issuerCubit.resolveDisplay();

      expect(issuerCubit.state.name, 'Example Issuer');
      expect(issuerCubit.state.credentialDisplay, isNull);
      expect(issuerCubit.state.credentialSupported, isNull);
    });

    test('keeps no name and no logo when no URL serves metadata', () async {
      final issuerCubit = cubit(trustedList: _trustedList());

      await issuerCubit.resolveDisplay();

      expect(issuerCubit.state, const ReaderIssuerState(isTrusted: true));
    });
  });
}
