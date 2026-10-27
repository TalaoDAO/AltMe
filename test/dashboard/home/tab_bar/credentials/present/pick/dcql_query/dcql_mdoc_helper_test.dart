import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/dcql_query/dcql_mdoc_helper.dart';
import 'package:altme/oidc4vc/helper_function/mdoc_credential_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc/mdoc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

import '../../../../../../../oidc4vc/support/issuer_signed_fixture.dart';

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

class _MockCredential extends Mock implements Credential {}

void main() {
  late CredentialModel mdl;

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() async {
    final data = await getMdocCredentialData(
      issuerSigned: testIssuerSigned(),
      credentialType: 'mDL',
      platformKeys: _MockPlatformP256Keys(),
    );
    mdl = CredentialModel(
      id: 'mdl',
      image: '',
      shareLink: '',
      data: data,
      credentialPreview: _MockCredential(),
      format: 'mso_mdoc',
      keyId: 'mdoc_1',
    );
  });

  group('mdocDigitalCredential', () {
    test('exposes the name spaces and doctype for DCQL', () {
      final credential = mdocDigitalCredential(mdl)!;

      expect(credential.docType, mdlDocType);
      expect(credential.getValueByPath([mdlNameSpace, 'age_over_18']), isTrue);
      expect(credential.nameSpaces.keys, [mdlNameSpace]);
    });

    test('is null for a credential that is not an mdoc', () {
      expect(mdocDigitalCredential(mdl.copyWith(format: 'dc+sd-jwt')), isNull);
    });
  });

  group('oid4vpSessionTranscript', () {
    test('uses client_id, nonce and the raw response_uri', () {
      final uri = Uri(
        queryParameters: {
          'client_id': 'x509_san_dns:verifier.example',
          'nonce': 'n',
          'response_uri': 'https://verifier.example/response',
          'response_mode': 'direct_post',
        },
      );

      expect(
        oid4vpSessionTranscript(uri: uri),
        SessionTranscript.oid4vp(
          clientId: 'x509_san_dns:verifier.example',
          nonce: 'n',
          responseUri: 'https://verifier.example/response',
        ),
      );
    });

    test('binds the encryption key thumbprint for direct_post.jwt', () {
      final jwk = {
        'kty': 'EC',
        'crv': 'P-256',
        'use': 'enc',
        'alg': 'ECDH-ES',
        'kid': 'k1',
        'x': 'f83OJ3D2xF1Bg8vub9tLe1gHMzV76e8Tus9uPHvRVEU',
        'y': 'x_FEzRu9m36HLN_tue659LNpXW6pCyStikYjKIWI5a0',
      };
      final uri = Uri(
        queryParameters: {
          'client_id': 'c',
          'nonce': 'n',
          'response_uri': 'https://r',
          'response_mode': 'direct_post.jwt',
        },
      );

      final transcript = oid4vpSessionTranscript(
        uri: uri,
        clientMetadata: {
          'jwks': {
            'keys': [jwk],
          },
          'encrypted_response_enc_values_supported': ['A128GCM'],
        },
      );

      expect(
        transcript,
        SessionTranscript.oid4vp(
          clientId: 'c',
          nonce: 'n',
          responseUri: 'https://r',
          jwkThumbprint: SessionTranscript.jwkThumbprint(jwk),
        ),
      );
    });
  });

  group('buildMdocPresentation', () {
    test(
      'discloses the requested elements, signed by the platform key',
      () async {
        final keys = _MockPlatformP256Keys();
        when(
          () => keys.signDigest('mdoc_1', any()),
        ).thenAnswer((_) async => Uint8List(64));

        final vpToken = await buildMdocPresentation(
          credential: mdl,
          requestedPaths: [
            [mdlNameSpace, 'age_over_18'],
          ],
          sessionTranscript: const [null, null, null],
          platformKeys: keys,
        );

        final response =
            cborDecode(base64Url.decode(base64Url.normalize(vpToken)))! as Map;
        final document = (response['documents']! as List).single as Map;
        final items =
            ((document['issuerSigned']! as Map)['nameSpaces']!
                    as Map)[mdlNameSpace]!
                as List;
        expect(document['docType'], mdlDocType);
        expect(items, hasLength(1));
        expect(
          ((items.single as CborTag).decodeEmbedded()!
              as Map)['elementIdentifier'],
          'age_over_18',
        );
        verify(() => keys.signDigest('mdoc_1', any())).called(1);
      },
    );
  });
}
