import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:json_path/json_path.dart';

Future<CredentialManifest> getCredentialManifestFromAltMe(
  DioClient client,
) async {
  final dynamic wellKnown = await client.get(
    'https://issuer.talao.co/.well-known/openid-configuration',
  );
  final JsonPath credentialManifetPath = JsonPath(r'$..credential_manifest');
  final credentialManifest = CredentialManifest.fromJson(
    credentialManifetPath.read(wellKnown).first.value as Map<String, dynamic>,
  );
  return credentialManifest;
}
