import 'dart:convert';

import 'package:did_kit/src/didkit_interface.dart';
import 'package:did_kit/src/didkit_wrapper.dart';
import 'package:dio/dio.dart';

class DIDKitProvider {
  DIDKitProvider({DIDKitInterface? didKit})
      : didKit = didKit ?? DIDKitWrapper();

  final DIDKitInterface didKit;

  String getVersion() {
    return didKit.getVersion();
  }

  String generateEd25519Key() {
    return didKit.generateEd25519Key();
  }

  String keyToDID(String methodName, String key) {
    return didKit.keyToDID(methodName, key);
  }

  Future<String> keyToVerificationMethod(String methodName, String key) async {
    return didKit.keyToVerificationMethod(methodName, key);
  }

  Future<String> issueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return didKit.issueCredential(credential, options, key);
  }

  Future<String> verifyCredential(
    String credential,
    String options,
  ) async {
    final credentialWithEbeddedContext = await _loadContext(credential);
    final verification =
        await didKit.verifyCredential(credentialWithEbeddedContext, options);
    return verification;
  }

  Future<String> issuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return didKit.issuePresentation(presentation, options, key);
  }

  Future<String> verifyPresentation(
    String presentation,
    String options,
  ) async {
    return didKit.verifyPresentation(presentation, options);
  }

  Future<String> resolveDID(
    String did,
    String inputMetadata,
  ) async {
    return didKit.resolveDID(did, inputMetadata);
  }

  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  ) async {
    return didKit.dereferenceDIDURL(didUrl, inputMetadata);
  }

  Future<String> didAuth(
    String did,
    String options,
    String key,
  ) async {
    return didKit.didAuth(did, options, key);
  }

  Future<String> _loadContext(String credential) async {
    const didKitContext = [
      'https://www.w3.org/2018/credentials/v1',
      'https://www.w3.org/2018/credentials/examples/v1',
      'https://www.w3.org/ns/odrl.jsonld',
      'https://schema.org/docs/jsonldcontext.jsonld',
      'https://w3id.org/security/v1',
      'https://w3id.org/security/v2',
      'https://www.w3.org/ns/did/v1',
      'https://w3id.org/did-resolution/v1',
      'https://identity.foundation/EcdsaSecp256k1RecoverySignature2020/lds-ecdsa-secp256k1-recovery2020-0.0.jsonld',
      'https://w3id.org/security/suites/secp256k1recovery-2020/v2',
      'https://w3c-ccg.github.io/lds-jws2020/contexts/lds-jws2020-v1.json',
      'https://w3id.org/security/suites/jws-2020/v1',
      'https://w3id.org/security/suites/ed25519-2020/v1',
      'https://w3id.org/security/suites/blockchain-2021/v1',
      'https://w3id.org/citizenship/v1',
      'https://w3id.org/vaccination/v1',
      'https://w3id.org/traceability/v1',
      'https://w3id.org/security/bbs/v1',
      'https://identity.foundation/presentation-exchange/submission/v1',
      'https://w3id.org/vdl/v1',
      'https://w3id.org/wallet/v1',
      'https://w3id.org/zcap/v1',
      'https://w3id.org/vc-revocation-list-2020/v1',
      'https://w3id.org/vc/status-list/2021/v1',
      'https://demo.didkit.dev/2022/cacao-zcap/contexts/v1.json',
      'https://w3c-ccg.github.io/vc-ed/plugfest-1-2022/jff-vc-edu-plugfest-1-context.json',
      'https://identity.foundation/linked-vp/contexts/v1',
      'https://identity.foundation/.well-known/did-configuration/v1',
    ];

    final json = jsonDecode(credential);

    /// key @context is an array. If an element is an url starting with http
    /// not present in didKitContext, get the web content with Dio package and
    /// put it in the array instead of the url
    if (json['@context'] is List) {
      final context = json['@context'] as List<dynamic>;
      for (var i = 0; i < context.length; i++) {
        final valueToTest = context[i];
        if (valueToTest is String) {
          if (valueToTest.startsWith('http') &&
              !didKitContext.contains(context[i])) {
            final response = await Dio().get<String>(valueToTest);
            if (response.statusCode == 200) {
              final newContext = jsonDecode(response.data!);
              // ignore: avoid_dynamic_calls
              context[i] = newContext['@context'];
            }
          }
        }
      }
      json['@context'] = context;
    }

    return jsonEncode(json);
  }
}
