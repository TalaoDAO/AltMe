import 'dart:convert';

import 'package:credential_manifest/credential_manifest.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<CredentialManifest> getCredentialManifestFromAltMe(
  OIDC4VC oidc4vc,
) async {
  final OpenIdConfiguration openIdConfiguration = await oidc4vc.getOpenIdConfig(
    'https://issuer.talao.co',
  );
  final JsonPath credentialManifetPath = JsonPath(r'$..credential_manifest');
  final credentialManifest = CredentialManifest.fromJson(
    credentialManifetPath
        .read(jsonDecode(jsonEncode(openIdConfiguration)))
        .first
        .value as Map<String, dynamic>,
  );
  return credentialManifest;
}
