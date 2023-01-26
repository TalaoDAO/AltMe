import 'dart:convert';

import 'package:credential_manifest/src/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:json_path/json_path.dart';

Future<CredentialManifest> getCredentialManifest(
    Dio client, String baseUrl, String type) async {
  final dynamic wellKnown = await client.get<String>(
    '$baseUrl/.well-known/openid-configuration',
  );
  final JsonPath credentialManifetPath = JsonPath(
    r'$..credential_manifests, $..credential_manifest',
  );
  final credentialManifest = CredentialManifest.fromJson(
    credentialManifetPath.read(jsonEncode(wellKnown.data)).first.value
        as Map<String, dynamic>,
  );
  credentialManifest.outputDescriptors
      ?.removeWhere((element) => element.id != type);

  return credentialManifest;
}
