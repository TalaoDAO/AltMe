import 'package:altme/app/app.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:json_path/json_path.dart';

Future<CredentialManifest> getCredentialManifestFromAltMe(
  DioClient client,
) async {
  final Map<String, dynamic> wellKnown = await getOpenIdConfig(
    baseUrl: 'https://issuer.talao.co',
    client: client.dio,
  );
  final JsonPath credentialManifetPath = JsonPath(r'$..credential_manifest');
  final credentialManifest = CredentialManifest.fromJson(
    credentialManifetPath.read(wellKnown).first.value as Map<String, dynamic>,
  );
  return credentialManifest;
}
