import 'package:did_kit/src/did_kit_wrapper.dart';

///get instance
DIDKitProvider get getDidKit => DIDKitProvider(DIDKitWrapper());

///DidKitProvider
class DIDKitProvider {
  ///
  factory DIDKitProvider(DIDKitWrapper didKitWrapper) {
    _instance ??= DIDKitProvider._(didKitWrapper);
    return _instance!;
  }

  DIDKitProvider._(this.didKit);

  static DIDKitProvider? _instance;

  ///
  final DIDKitWrapper didKit;

  ///getVersion
  String getVersion() {
    return didKit.getVersion();
  }

  ///generateEd25519Key
  String generateEd25519Key() {
    return didKit.generateEd25519Key();
  }

  ///keyToDID
  String keyToDID(String methodName, String key) {
    return didKit.keyToDID(methodName, key);
  }

  ///keyToVerificationMethod
  Future<String> keyToVerificationMethod(String methodName, String key) async {
    return didKit.keyToVerificationMethod(methodName, key);
  }

  ///issueCredential
  Future<String> issueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return didKit.issueCredential(credential, options, key);
  }

  ///verifyCredential
  Future<String> verifyCredential(
    String credential,
    String options,
  ) async {
    return didKit.verifyCredential(credential, options);
  }

  ///issuePresentation
  Future<String> issuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return didKit.issuePresentation(presentation, options, key);
  }

  ///verifyPresentation
  Future<String> verifyPresentation(
    String presentation,
    String options,
  ) async {
    return didKit.verifyPresentation(presentation, options);
  }

  ///resolveDID
  Future<String> resolveDID(
    String did,
    String inputMetadata,
  ) async {
    return didKit.resolveDID(did, inputMetadata);
  }

  ///dereferenceDIDURL
  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  ) async {
    return didKit.dereferenceDIDURL(didUrl, inputMetadata);
  }

  ///DIDAuth
  Future<String> didAuth(
    String did,
    String options,
    String key,
  ) async {
    return didKit.didAuth(did, options, key);
  }
}
