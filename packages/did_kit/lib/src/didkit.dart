import 'didkit_stub.dart'
    if (dart.library.io) 'didkit_io.dart'
    if (dart.library.js) 'didkit_js.dart';

abstract class DIDKitProvider {
  static DIDKitProvider? _instance;

  static DIDKitProvider get instance {
    _instance ??= getProvider();
    return _instance!;
  }

  String getVersion();

  String generateEd25519Key();

  String keyToDID(String methodName, String key);

  Future<String> keyToVerificationMethod(String methodName, String key);

  Future<String> issueCredential(
    String credential,
    String options,
    String key,
  );

  Future<String> verifyCredential(
    String credential,
    String options,
  );

  Future<String> issuePresentation(
    String presentation,
    String options,
    String key,
  );

  Future<String> verifyPresentation(
    String presentation,
    String options,
  );

  Future<String> resolveDID(
    String did,
    String inputMetadata,
  );

  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  );

  Future<String> DIDAuth(
    String did,
    String options,
    String key,
  );
}
