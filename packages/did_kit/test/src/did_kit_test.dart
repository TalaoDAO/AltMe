import 'dart:convert';

import 'package:did_kit/did_kit.dart';
import 'package:did_kit/src/did_kit_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDIDKitProvider extends Mock implements DIDKitProvider {}

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
    'credentialSubject': {'id': 'did:example:d23dd687a7dc6787646f2eb98d0'},
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
      'credentialSubject': {'id': 'did:example:d23dd687a7dc6787646f2eb98d0'},
    },
  };

  final proofOptions = jsonEncode({
    'proofPurpose': 'assertionMethod',
    'verificationMethod': vm,
    'challenge': 'Uuid().v4()',
  });

  late MockDIDKitProvider mockDIDKitProvider;

  setUp(() {
    mockDIDKitProvider = MockDIDKitProvider();
  });

  group('DidKitProvider', () {
    test('verify did kit version is $didKitVersion', () {
      when(() => mockDIDKitProvider.getVersion()).thenReturn(didKitVersion);
      expect(mockDIDKitProvider.getVersion(), didKitVersion);
    });

    test('generateEd25519Key method mocked', () {
      when(() => mockDIDKitProvider.generateEd25519Key())
          .thenReturn(ed25519Key);
      expect(mockDIDKitProvider.generateEd25519Key(), ed25519Key);
    });

    test('keyToDID method mocked', () async {
      when(() => mockDIDKitProvider.keyToDID(key, ed25519Key)).thenReturn(did);
      expect(
        mockDIDKitProvider.keyToDID(key, ed25519Key),
        equals(did),
      );
    });

    test('keyToVerificationMethod method mocked', () async {
      when(() => mockDIDKitProvider.keyToVerificationMethod(key, ed25519Key))
          .thenAnswer((_) async => vm);
      expect(
        await mockDIDKitProvider.keyToVerificationMethod(key, ed25519Key),
        equals(vm),
      );
    });

    test('issueCredential method mocked', () async {
      when(
        () => mockDIDKitProvider.issueCredential(
          jsonEncode(credential),
          jsonEncode(options),
          key,
        ),
      ).thenAnswer((_) async => vc);

      expect(
        await mockDIDKitProvider.issueCredential(
          jsonEncode(credential),
          jsonEncode(options),
          key,
        ),
        equals(vc),
      );
    });

    test('verifyCredential method mocked', () async {
      when(
        () =>
            mockDIDKitProvider.verifyCredential(vc, jsonEncode(verifyOptions)),
      ).thenAnswer((_) async => verifyResult);
      expect(
        await mockDIDKitProvider.verifyCredential(
          vc,
          jsonEncode(verifyOptions),
        ),
        equals(verifyResult),
      );
    });

    test('issuePresentation method mocked', () async {
      when(
        () => mockDIDKitProvider.issuePresentation(
          jsonEncode(presentation),
          jsonEncode(options),
          key,
        ),
      ).thenAnswer((_) async => vc);
      expect(
        await mockDIDKitProvider.issuePresentation(
          jsonEncode(presentation),
          jsonEncode(options),
          key,
        ),
        equals(vc),
      );
    });

    test('verifyPresentation method mocked', () async {
      when(
        () => mockDIDKitProvider.verifyPresentation(
          vc,
          jsonEncode(verifyOptions),
        ),
      ).thenAnswer((_) async => verifyResult);
      expect(
        await mockDIDKitProvider.verifyPresentation(
          vc,
          jsonEncode(verifyOptions),
        ),
        equals(verifyResult),
      );
    });

    test('resolveDID method mocked', () async {
      when(
        () => mockDIDKitProvider.resolveDID(did, '{}'),
      ).thenAnswer((_) async => '');
      expect(
        await mockDIDKitProvider.resolveDID(did, '{}'),
        isInstanceOf<String>(),
      );
    });

    test('dereferenceDIDURL method mocked', () async {
      when(
        () => mockDIDKitProvider.dereferenceDIDURL(vm, '{}'),
      ).thenAnswer((_) async => '');
      expect(
        await mockDIDKitProvider.dereferenceDIDURL(vm, '{}'),
        isInstanceOf<String>(),
      );
    });

    test('didAuth method mocked', () async {
      when(
        () => mockDIDKitProvider.didAuth(did, proofOptions, key),
      ).thenAnswer((_) async => '');
      expect(
        await mockDIDKitProvider.didAuth(did, proofOptions, key),
        isInstanceOf<String>(),
      );
    });
  });
}
