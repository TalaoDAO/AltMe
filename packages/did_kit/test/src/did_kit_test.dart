// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:did_kit/did_kit.dart';
import 'package:did_kit/src/did_kit_core.dart';
import 'package:didkit/didkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDidKitCore extends Mock implements DIDKitCore {}

void main() {
  final mockDidKitCore = MockDidKitCore();
  final didKitProvider = DIDKitProvider(mockDidKitCore);

  //
  const didKitVersion = '0.3.0';
  const ed25519Key =
      '''{"kty":"OKP","crv":"Ed25519","x":"VW4M2_QGNxcplUzDMflsguYD-doia0FdKnmbQXdT4gU","d":"lwKFU-Ol4m_WM_V-3Fp_OIuN6VlOIxAr53Y9QCPP2R4"}''';
  const did = 'did:key:z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56';
  const key = 'key';
  const vm =
      'did:key:z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56#z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56';

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

  group('DidKit', () {
    test('can be instantiated', () {
      expect(getDidKit, isNotNull);
    });

    test('verify did kit version is $didKitVersion', () {
      when(mockDidKitCore.getVersion).thenReturn(didKitVersion);
      expect(didKitProvider.getVersion(), didKitVersion);
    });

    test('exceptions', () async {
      when(() => mockDidKitCore.issueCredential('', '', '')).thenThrow(
        DIDKitException(0, ''),
      );
      expect(
        () => didKitProvider.issueCredential('', '', ''),
        throwsA(isInstanceOf<DIDKitException>()),
      );

      when(() => mockDidKitCore.issuePresentation('', '', '')).thenThrow(
        DIDKitException(0, ''),
      );
      expect(
        () => didKitProvider.issuePresentation('', '', ''),
        throwsA(isInstanceOf<DIDKitException>()),
      );

      when(() => mockDidKitCore.verifyCredential('', '')).thenThrow(
        DIDKitException(0, ''),
      );
      expect(
        () => didKitProvider.verifyCredential('', ''),
        throwsA(isInstanceOf<DIDKitException>()),
      );

      when(() => mockDidKitCore.verifyPresentation('', '')).thenThrow(
        DIDKitException(0, ''),
      );
      expect(
        () => didKitProvider.verifyPresentation('', ''),
        throwsA(isInstanceOf<DIDKitException>()),
      );
    });

    test('generateEd25519Key', () {
      when(mockDidKitCore.generateEd25519Key).thenReturn(ed25519Key);
      expect(didKitProvider.generateEd25519Key(), equals(ed25519Key));
    });

    test('keyToDID', () async {
      when(() => mockDidKitCore.keyToDID(key, ed25519Key)).thenReturn(did);
      expect(
        didKitProvider.keyToDID(key, ed25519Key),
        equals(did),
      );
    });

    test('keyToVerificationMethod', () async {
      when(() => mockDidKitCore.keyToVerificationMethod(key, ed25519Key))
          .thenAnswer((_) async => vm);
      expect(
        await didKitProvider.keyToVerificationMethod(key, ed25519Key),
        equals(vm),
      );
    });

    test('issueCredential', () async {
      when(
        () => mockDidKitCore.issueCredential(
          jsonEncode(credential),
          jsonEncode(options),
          key,
        ),
      ).thenAnswer((_) async => vc);
      expect(
        await didKitProvider.issueCredential(
          jsonEncode(credential),
          jsonEncode(options),
          key,
        ),
        equals(vc),
      );
    });

    test('verifyCredential', () async {
      when(() => mockDidKitCore.verifyCredential(vc, jsonEncode(verifyOptions)))
          .thenAnswer((_) async => verifyResult);
      expect(
        await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions)),
        equals(verifyResult),
      );
    });

    test('issuePresentation', () async {
      when(() => mockDidKitCore.issuePresentation(
              jsonEncode(presentation), jsonEncode(options), key))
          .thenAnswer((_) async => vc);
      expect(
        await didKitProvider.issuePresentation(
            jsonEncode(presentation), jsonEncode(options), key),
        equals(vc),
      );
    });

    test('verifyPresentation', () async {
      when(
        () => mockDidKitCore.verifyPresentation(
          vc,
          jsonEncode(verifyOptions),
        ),
      ).thenAnswer((_) async => verifyResult);
      expect(
        await didKitProvider.verifyPresentation(
          vc,
          jsonEncode(verifyOptions),
        ),
        equals(verifyResult),
      );
    });

    test('resolveDID', () async {
      when(() => mockDidKitCore.resolveDID(did, '{}')).thenAnswer((_) async => '');
      expect(
        await didKitProvider.resolveDID(did, '{}'),
        isInstanceOf<String>(),
      );
    });

    test('dereferenceDIDURL', () async {
      when(() => mockDidKitCore.dereferenceDIDURL(vm, '{}'))
          .thenAnswer((_) async => '');
      expect(
        await didKitProvider.dereferenceDIDURL(vm, '{}'),
        isInstanceOf<String>(),
      );
    });

    test('didAuth', () async {
      when(() => mockDidKitCore.didAuth(did, proofOptions, key))
          .thenAnswer((_) async => '');
      expect(
        await didKitProvider.didAuth(did, proofOptions, key),
        isInstanceOf<String>(),
      );
    });
  });
}
