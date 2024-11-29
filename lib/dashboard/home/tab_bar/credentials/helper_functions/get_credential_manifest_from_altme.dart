import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<CredentialManifest> getCredentialManifestFromAltMe({
  required OIDC4VC oidc4vc,
  required OIDC4VCIDraftType oidc4vciDraftType,
}) async {
  final openIdConfigurationData = await oidc4vc.getIssuerMetaData(
    baseUrl: 'https://issuer.talao.co',
    dio: Dio(),
  );
  final JsonPath credentialManifetPath = JsonPath(r'$..credential_manifest');
  final credentialManifest = CredentialManifest.fromJson(
    credentialManifetPath.read(openIdConfigurationData).first.value!
        as Map<String, dynamic>,
  );
  return credentialManifest;
}
