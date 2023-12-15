import 'package:credential_manifest/credential_manifest.dart';

import 'package:json_path/json_path.dart';

Future<CredentialManifest?> getCredentialManifest({
  required String credentialType,
  required Map<String, dynamic> openidConfigurationJson,
}) async {
  try {
    final JsonPath credentialManifestPath = JsonPath(
      // ignore: prefer_interpolation_to_compose_strings
      r'$..credential_manifests[?(@.id=="' + credentialType + '")]',
    );

    /// select first credential manifest
    final credentialManifestMap = credentialManifestPath
        .read(openidConfigurationJson)
        .first
        .value as Map<String, dynamic>;

    /// create credentialManisfest object
    final credentialManifest = CredentialManifest.fromJson(
      credentialManifestMap,
    );

    return credentialManifest;
  } catch (e) {
    return null;
  }
}
