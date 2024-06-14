import 'dart:convert';

import 'package:did_kit/did_kit.dart';
import 'package:did_kit/src/did_kit_provider.dart';
import 'package:did_kit/src/didkit_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDIDKitInterface extends Mock implements DIDKitInterface {}

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

  late DIDKitInterface mockDIDKit;
  late DIDKitProvider didKitProvider;

  setUp(() {
    mockDIDKit = MockDIDKitInterface();
    didKitProvider = DIDKitProvider(didKit: mockDIDKit);
  });

  group('DidKitProvider', () {
    test('verify did kit version is $didKitVersion', () {
      when(() => mockDIDKit.getVersion()).thenReturn(didKitVersion);
      expect(didKitProvider.getVersion(), didKitVersion);
      verify(() => mockDIDKit.getVersion()).called(1);
    });

    test('generateEd25519Key returns correct key', () {
      when(() => mockDIDKit.generateEd25519Key()).thenReturn(ed25519Key);
      expect(didKitProvider.generateEd25519Key(), equals(ed25519Key));
      verify(() => mockDIDKit.generateEd25519Key()).called(1);
    });

    test('keyToDID returns correct DID', () {
      when(() => mockDIDKit.keyToDID(any(), any())).thenReturn(did);

      expect(
        didKitProvider.keyToDID(key, ed25519Key),
        equals(did),
      );
      verify(() => mockDIDKit.keyToDID(key, ed25519Key)).called(1);
    });

    test('keyToVerificationMethod returns correct verification method',
        () async {
      when(() => mockDIDKit.keyToVerificationMethod(any(), any()))
          .thenAnswer((_) async => vm);

      expect(
        await didKitProvider.keyToVerificationMethod(key, ed25519Key),
        equals(vm),
      );
      verify(() => mockDIDKit.keyToVerificationMethod(key, ed25519Key))
          .called(1);
    });

    test('issueCredential returns correct vc', () async {
      when(() => mockDIDKit.issueCredential(any(), any(), any()))
          .thenAnswer((_) async => vc);
      expect(
        await didKitProvider.issueCredential(
          jsonEncode(credential),
          jsonEncode(options),
          key,
        ),
        equals(vc),
      );
      verify(
        () => mockDIDKit.issueCredential(
          jsonEncode(credential),
          jsonEncode(options),
          key,
        ),
      ).called(1);
    });

    test('verifyCredential returns correct verifyResult', () async {
      when(() => mockDIDKit.verifyCredential(any(), any()))
          .thenAnswer((_) async => verifyResult);
      expect(
        await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions)),
        equals(verifyResult),
      );
      verify(
        () => mockDIDKit.verifyCredential(vc, jsonEncode(verifyOptions)),
      ).called(1);
    });

    test('issuePresentation returns correct vc', () async {
      when(() => mockDIDKit.issuePresentation(any(), any(), any()))
          .thenAnswer((_) async => vc);
      expect(
        await didKitProvider.issuePresentation(
          jsonEncode(presentation),
          jsonEncode(options),
          key,
        ),
        equals(vc),
      );
      verify(
        () => mockDIDKit.issuePresentation(
          jsonEncode(presentation),
          jsonEncode(options),
          key,
        ),
      ).called(1);
    });

    test('verifyPresentation returns correct verifyResult', () async {
      when(() => mockDIDKit.verifyPresentation(any(), any()))
          .thenAnswer((_) async => verifyResult);
      expect(
        await didKitProvider.verifyPresentation(
          vc,
          jsonEncode(verifyOptions),
        ),
        equals(verifyResult),
      );
      verify(
        () => mockDIDKit.verifyPresentation(
          vc,
          jsonEncode(verifyOptions),
        ),
      ).called(1);
    });

    test('resolveDID method mocked', () async {
      when(() => mockDIDKit.resolveDID(any(), any()))
          .thenAnswer((_) async => '');
      expect(
        await didKitProvider.resolveDID(did, '{}'),
        isInstanceOf<String>(),
      );
      verify(
        () => mockDIDKit.resolveDID(did, '{}'),
      ).called(1);
    });

    test('dereferenceDIDURL method mocked', () async {
      when(() => mockDIDKit.dereferenceDIDURL(any(), any()))
          .thenAnswer((_) async => '');
      expect(
        await didKitProvider.dereferenceDIDURL(vm, '{}'),
        isInstanceOf<String>(),
      );
      verify(
        () => mockDIDKit.dereferenceDIDURL(vm, '{}'),
      ).called(1);
    });

    test('didAuth method mocked', () async {
      when(() => mockDIDKit.didAuth(any(), any(), any()))
          .thenAnswer((_) async => '');
      expect(
        await didKitProvider.didAuth(did, proofOptions, key),
        isInstanceOf<String>(),
      );
      verify(
        () => mockDIDKit.didAuth(did, proofOptions, key),
      ).called(1);
    });
  });
}
