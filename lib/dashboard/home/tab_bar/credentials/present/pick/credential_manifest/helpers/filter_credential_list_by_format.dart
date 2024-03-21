import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:oidc4vc/oidc4vc.dart';

List<CredentialModel> filterCredenialListByFormat({
  required VCFormatType vcFormatType,
  required Map<String, dynamic>? clientMetaData,
  required List<CredentialModel> credentialList,
  required PresentationDefinition presentationDefinition,
  required List<Field> filterList,
}) {
  final credentials = List<CredentialModel>.from(credentialList);
  if (filterList.isNotEmpty) {
    final isJwtVpInJwtVCRequired = presentationDefinition.format?.jwtVp != null;

    if (isJwtVpInJwtVCRequired) {
      credentials.removeWhere(
        (CredentialModel credentialModel) => credentialModel.jwt == null,
      );
    }

    final (presentLdpVc, presentJwtVc, presentJwtVcJson, presentVcSdJwt) =
        getPresentVCDetails(
      clientMetaData: clientMetaData,
      presentationDefinition: presentationDefinition,
      vcFormatType: vcFormatType,
    );

    credentials.removeWhere(
      (CredentialModel credentialModel) {
        /// remove ldpVc
        if (presentLdpVc) {
          return credentialModel.format != VCFormatType.ldpVc.value;
        }

        /// remove jwtVc
        if (presentJwtVc) {
          return credentialModel.format != VCFormatType.jwtVc.value;
        }

        /// remove JwtVcJson
        if (presentJwtVcJson) {
          return credentialModel.format != VCFormatType.jwtVcJson.value;
        }

        /// remove vcSdJwt
        if (presentVcSdJwt) {
          return credentialModel.format != VCFormatType.vcSdJWT.value;
        }

        return false;
      },
    );
  }
  return credentials;
}
