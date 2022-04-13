import 'package:didkit/didkit.dart';

///DIDKitWrapper
class DIDKitWrapper {
  ///DIDKitWrapper
  factory DIDKitWrapper() {
    _instance ??= DIDKitWrapper._();
    return _instance!;
  }

  DIDKitWrapper._();

  static DIDKitWrapper? _instance;

  ///getVersion
  String getVersion() {
    return DIDKit.getVersion();
  }

  ///generateEd25519Key
  String generateEd25519Key() {
    return DIDKit.generateEd25519Key();
  }

  ///generateEd25519Key
  String keyToDID(String methodName, String key) {
    return DIDKit.keyToDID(methodName, key);
  }

  ///keyToVerificationMethod
  Future<String> keyToVerificationMethod(String methodName, String key) async {
    return DIDKit.keyToVerificationMethod(methodName, key);
  }

  ///issueCredential
  Future<String> issueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return DIDKit.issueCredential(credential, options, key);
  }

  ///verifyCredential
  Future<String> verifyCredential(
    String credential,
    String options,
  ) async {
    return DIDKit.verifyCredential(credential, options);
  }

  ///issuePresentation
  Future<String> issuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return DIDKit.issuePresentation(presentation, options, key);
  }

  ///verifyPresentation
  Future<String> verifyPresentation(
    String presentation,
    String options,
  ) async {
    return DIDKit.verifyPresentation(presentation, options);
  }

  ///resolveDID
  Future<String> resolveDID(
    String did,
    String inputMetadata,
  ) async {
    return DIDKit.resolveDID(did, inputMetadata);
  }

  ///dereferenceDIDURL
  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  ) async {
    return DIDKit.dereferenceDIDURL(didUrl, inputMetadata);
  }

  ///DIDAuth
  Future<String> didAuth(
    String did,
    String options,
    String key,
  ) async {
    return DIDKit.DIDAuth(did, options, key);
  }
}
