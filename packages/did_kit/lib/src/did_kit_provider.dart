import 'package:did_kit/src/didkit_interface.dart';
import 'package:did_kit/src/didkit_wrapper.dart';

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
    return didKit.verifyCredential(credential, options);
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
}
