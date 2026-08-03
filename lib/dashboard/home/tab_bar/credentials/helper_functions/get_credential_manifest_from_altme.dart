import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<CredentialManifest> getCredentialManifestFromAltMe({
  required OIDC4VC oidc4vc,
  required OIDC4VCIDraftType oidc4vciDraftType,
}) async {
  final openIdConfigurationData = await oidc4vc.getIssuerMetaData(
    baseUrl: 'https://issuer.talao.co',
    dio: Dio(),
  );
  final credentialManifest = openIdConfigurationData.credentialManifest;
  if (credentialManifest == null) {
    throw Exception('Credential Manifest from Talao is null');
  }
  return credentialManifest;
}
