import 'dart:convert';

import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:json_path/json_path.dart';

Future<CredentialManifest?> getCredentialManifest({
  required Dio client,
  required String baseUrl,
  required String credentialType,
  required bool schemaForType,
}) async {
  try {
    final dynamic wellKnown = await client.get<String>(
      '$baseUrl/.well-known/openid-configuration',
    );

    if (schemaForType) {
      final JsonPath credentialManifestPath =
          JsonPath(r'$..credential_manifests');

      final credentialManifestsMap = credentialManifestPath
          .read(jsonDecode(wellKnown.data as String))
          .first
          .value as List;

      for (final map in credentialManifestsMap) {
        final credentialManifest = CredentialManifest.fromJson(
          map as Map<String, dynamic>,
        );
        if (credentialManifest.outputDescriptors != null) {
          for (final outputDescriptor
              in credentialManifest.outputDescriptors!) {
            if (outputDescriptor.schema == credentialType) {
              return credentialManifest;
            }
          }
        }
      }

      return null;
    } else {
      final JsonPath credentialManifestPath = JsonPath(
        // ignore: prefer_interpolation_to_compose_strings
        r'$..credential_manifests[?(@.id=="' + credentialType + '")]',
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

      return credentialManifest;
    }
  } catch (e) {
    return null;
  }
}
