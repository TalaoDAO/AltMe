import 'dart:convert';

import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:json_path/json_path.dart';

Future<CredentialManifest> getCredentialManifest(
  Dio client,
  String baseUrl,
  String type,
) async {
  final dynamic wellKnown = await client.get<String>(
    '$baseUrl/.well-known/openid-configuration',
  );
  final JsonPath credentialManifestPath = JsonPath(
    r'$..credential_manifests[?(@.id)]',
  );

  /// select first credential manifest
  final credentialManifestMap = credentialManifestPath
      .read(jsonDecode(wellKnown.data as String))
      .first
      .value as Map<String, dynamic>;

  /// create credentialManisfest object
  final credentialManifest = CredentialManifest.fromJson(
    credentialManifestMap,
  );

  /// select wanted output desciptor
  final JsonPath outputDescriptorPath = JsonPath(
    // ignore: prefer_interpolation_to_compose_strings
    r'$..output_descriptors[?(@.schema=="' + type + '")]',
  );

  /// There are some possible issues with this way of filtering :-/
  final Map<String, dynamic> outputDescriptorMap = outputDescriptorPath
      .read(jsonDecode(wellKnown.data as String))
      .first
      .value as Map<String, dynamic>;
  final OutputDescriptor outputDescriptor =
      OutputDescriptor.fromJson(outputDescriptorMap);

  final CredentialManifest sanitizedCredentialManifest =
      credentialManifest.copyWith(outputDescriptors: [outputDescriptor]);

  return sanitizedCredentialManifest;
}
