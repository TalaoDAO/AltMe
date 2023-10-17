import 'dart:convert';

import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:json_path/json_path.dart';

Future<CredentialManifest?> getCredentialManifest({
  required Dio client,
  required String baseUrl,
  required String credentialType,
}) async {
  try {
    final dynamic wellKnown = await getOpenIdConfig(
      baseUrl: baseUrl,
      client: client,
    );

    final JsonPath credentialManifestPath = JsonPath(
      // ignore: prefer_interpolation_to_compose_strings
      r'$..credential_manifests[?(@.id=="' + credentialType + '")]',
    );

    /// select first credential manifest
    final credentialManifestMap = credentialManifestPath
        .read(wellKnown)
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

Future<Map<String, dynamic>> getOpenIdConfig({
  required String baseUrl,
  required Dio client,
}) async {
  final url = '$baseUrl/.well-known/openid-configuration';

  try {
    final dynamic response = await client.get<dynamic>(url);
    final data = response.data is String
        ? jsonDecode(response.data.toString()) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;
    return data;
  } catch (e) {
    if (e.toString().startsWith('Exception: Second_Attempt_Fail')) {
      throw Exception();
    } else {
      final data = await getOpenIdConfigSecondAttempt(
        baseUrl: baseUrl,
        client: client,
      );
      return data;
    }
  }
}

Future<Map<String, dynamic>> getOpenIdConfigSecondAttempt({
  required String baseUrl,
  required Dio client,
}) async {
  final url = '$baseUrl/.well-known/openid-credential-issuer';

  try {
    final response = await client.get<dynamic>(url);
    final data = response.data is String
        ? jsonDecode(response.data.toString()) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;
    return data;
  } catch (e) {
    throw Exception('Second_Attempt_Fail');
  }
}
