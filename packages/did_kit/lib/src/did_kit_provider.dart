import 'package:didkit/didkit.dart';

class DIDKitProvider {
  String getVersion() {
    return DIDKit.getVersion();
  }

  String generateEd25519Key() {
    return DIDKit.generateEd25519Key();
  }

  String keyToDID(String methodName, String key) {
    return DIDKit.keyToDID(methodName, key);
  }

  Future<String> keyToVerificationMethod(String methodName, String key) async {
    return DIDKit.keyToVerificationMethod(methodName, key);
  }

  Future<String> issueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return DIDKit.issueCredential(credential, options, key);
  }

  Future<String> verifyCredential(
    String credential,
    String options,
  ) async {
    return DIDKit.verifyCredential(credential, options);
  }

  Future<String> issuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return DIDKit.issuePresentation(presentation, options, key);
  }

  Future<String> verifyPresentation(
    String presentation,
    String options,
  ) async {
    return DIDKit.verifyPresentation(presentation, options);
  }

  Future<String> resolveDID(
    String did,
    String inputMetadata,
  ) async {
    return DIDKit.resolveDID(did, inputMetadata);
  }

  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  ) async {
    return DIDKit.dereferenceDIDURL(didUrl, inputMetadata);
  }

  Future<String> didAuth(
    String did,
    String options,
    String key,
  ) async {
    return DIDKit.DIDAuth(did, options, key);
  }
}
