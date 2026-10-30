import 'dart:convert';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/dcql_query/dcql_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';

class _MockCredential extends Mock implements Credential {}

String _encode(Map<String, dynamic> part) =>
    base64Url.encode(utf8.encode(jsonEncode(part))).replaceAll('=', '');

void main() {
  final issuerJwt =
      '${_encode({'alg': 'ES256', 'typ': 'dc+sd-jwt'})}.'
      '${_encode({'vct': 'https://openid4vc-hub.com/credentials/qtsp-service-user'})}'
      '.signature';
  final uri = Uri.parse(
    'openid4vp://?client_id=x509_hash%3Aabc&nonce=n-0S6_WzA2Mj',
  );
  final transactionDataTypes = TransactionDataTypes([
    const QesApprovalTransactionType(),
  ]);
  final transactionData = transactionDataTypes.parse(
    [
      _encode({
        'type': qesApprovalTransactionType,
        'credential_ids': ['qes_attestation'],
        'documentInfos': [
          {'label': 'Contract', 'hash': 'aGFzaA=='},
        ],
      }),
    ],
    credentialQueryIds: {'qes_attestation'},
  );
  final transactionClaims = transactionDataTypes.keyBindingClaims(
    transactionData,
  );

  CredentialModel credential() => CredentialModel(
    id: 'qes',
    image: '',
    shareLink: '',
    data: const {
      'cnf': {
        'jwk': {'kty': 'EC', 'crv': 'P-256', 'x': 'x', 'y': 'y'},
      },
    },
    credentialPreview: _MockCredential(),
    jwt: '$issuerJwt~',
    format: 'dc+sd-jwt',
    keyId: 'credential-key',
  );

  group('buildPresentation', () {
    late List<Map<String, dynamic>> signedPayloads;

    JwtSigner signer(String keyId) => (header, payload) async {
      signedPayloads.add(payload);
      return 'kb.jwt.signature';
    };

    setUp(() => signedPayloads = []);

    test('adds the transaction claims to the Key Binding JWT', () async {
      final presentation = await buildPresentation(
        credential: credential(),
        requestedPaths: const [],
        uri: uri,
        privateKey: const {},
        proofHeaderType: ProofHeaderType.jwk,
        credentialKeySigner: signer,
        transactionClaims: transactionClaims,
      );

      expect(presentation, '$issuerJwt~kb.jwt.signature');
      final payload = signedPayloads.single;
      expect(payload['aud'], 'x509_hash:abc');
      expect(payload['nonce'], 'n-0S6_WzA2Mj');
      expect(payload['sd_hash'], sh256Hash('$issuerJwt~'));
      expect(
        payload['transaction_data_hashes'],
        transactionClaims['transaction_data_hashes'],
      );
      expect(payload['transaction_data_hashes_alg'], 'sha-256');
      expect(
        payload[qesApprovalClaim],
        base64.encode(transactionData.single.digest),
      );
    });

    test('adds no transaction claim when none is given', () async {
      await buildPresentation(
        credential: credential(),
        requestedPaths: const [],
        uri: uri,
        privateKey: const {},
        proofHeaderType: ProofHeaderType.jwk,
        credentialKeySigner: signer,
      );

      expect(
        signedPayloads.single.keys,
        unorderedEquals(['nonce', 'aud', 'iat', 'sd_hash']),
      );
    });
  });
}
