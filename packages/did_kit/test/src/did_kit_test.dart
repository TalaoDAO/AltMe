import 'dart:convert';

import 'package:did_kit/did_kit.dart';
import 'package:did_kit/src/did_kit_provider.dart';
import 'package:didkit/didkit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const didKitVersion = '0.3.0';
  const ed25519Key =
      '''{"kty":"OKP","crv":"Ed25519","x":"VW4M2_QGNxcplUzDMflsguYD-doia0FdKnmbQXdT4gU","d":"lwKFU-Ol4m_WM_V-3Fp_OIuN6VlOIxAr53Y9QCPP2R4"}''';
  const did = 'did:key:z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56';
  const key = 'key';
  const vm =
      '''did:key:z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56#z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56''';

  const options = <String, dynamic>{
    'proofPurpose': 'assertionMethod',
    'verificationMethod': vm,
  };

  const credential = <String, dynamic>{
    '@context': 'https://www.w3.org/2018/credentials/v1',
    'id': 'http://example.org/credentials/3731',
    'type': ['VerifiableCredential'],
    'issuer': did,
    'issuanceDate': '2020-08-19T21:41:50Z',
    'credentialSubject': {'id': 'did:example:d23dd687a7dc6787646f2eb98d0'}
  };

  const vc = '';

  const verifyOptions = <String, dynamic>{'proofPurpose': 'assertionMethod'};

  const verifyResult = '';

  const presentation = <String, dynamic>{
    '@context': ['https://www.w3.org/2018/credentials/v1'],
    'id': 'http://example.org/presentations/3731',
    'type': ['VerifiablePresentation'],
    'holder': did,
    'verifiableCredential': {
      '@context': 'https://www.w3.org/2018/credentials/v1',
      'id': 'http://example.org/credentials/3731',
      'type': ['VerifiableCredential'],
      'issuer': 'did:example:30e07a529f32d234f6181736bd3',
      'issuanceDate': '2020-08-19T21:41:50Z',
      'credentialSubject': {'id': 'did:example:d23dd687a7dc6787646f2eb98d0'}
    }
  };

  final proofOptions = jsonEncode({
    'proofPurpose': 'assertionMethod',
    'verificationMethod': vm,
    'challenge': 'Uuid().v4()'
  });

  late DIDKitProvider didKitProvider;

  setUpAll(() {
    didKitProvider = DIDKitProvider();
  });

  group('DidKitProvider', () {
    test('verify did kit version is $didKitVersion', () {
      expect(didKitProvider.getVersion(), didKitVersion);
    });

    test('exceptions with empty inputs', () async {
      expect(
        () => didKitProvider.issueCredential('', '', ''),
        throwsA(isInstanceOf<DIDKitException>()),
      );
      expect(
        () => didKitProvider.issuePresentation('', '', ''),
        throwsA(isInstanceOf<DIDKitException>()),
      );
      expect(
        () => didKitProvider.verifyCredential('', ''),
        throwsA(isInstanceOf<DIDKitException>()),
      );
      expect(
        () => didKitProvider.verifyPresentation('', ''),
        throwsA(isInstanceOf<DIDKitException>()),
      );
    });

    test('generateEd25519Key method mocked', () {
      expect(didKitProvider.generateEd25519Key(), equals(ed25519Key));
    });

    test('keyToDID method mocked', () async {
      expect(
        didKitProvider.keyToDID(key, ed25519Key),
        equals(did),
      );
    });

    test('keyToVerificationMethod method mocked', () async {
      expect(
        await didKitProvider.keyToVerificationMethod(key, ed25519Key),
        equals(vm),
      );
    });

    test('issueCredential method mocked', () async {
      expect(
        await didKitProvider.issueCredential(
          jsonEncode(credential),
          jsonEncode(options),
          key,
        ),
        equals(vc),
      );
    });

    test('verifyCredential method mocked', () async {
      expect(
        await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions)),
        equals(verifyResult),
      );
    });

    test('issuePresentation method mocked', () async {
      expect(
        await didKitProvider.issuePresentation(
          jsonEncode(presentation),
          jsonEncode(options),
          key,
        ),
        equals(vc),
      );
    });

    test('verifyPresentation method mocked', () async {
      expect(
        await didKitProvider.verifyPresentation(
          vc,
          jsonEncode(verifyOptions),
        ),
        equals(verifyResult),
      );
    });

    test('resolveDID method mocked', () async {
      expect(
        await didKitProvider.resolveDID(did, '{}'),
        isInstanceOf<String>(),
      );
    });

    test('dereferenceDIDURL method mocked', () async {
      expect(
        await didKitProvider.dereferenceDIDURL(vm, '{}'),
        isInstanceOf<String>(),
      );
    });

    test('didAuth method mocked', () async {
      expect(
        await didKitProvider.didAuth(did, proofOptions, key),
        isInstanceOf<String>(),
      );
    });
  });
}
