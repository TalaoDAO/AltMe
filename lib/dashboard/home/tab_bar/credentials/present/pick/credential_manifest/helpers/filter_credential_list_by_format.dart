import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> filterCredenialListByFormat(
  List<CredentialModel> credentialList,
  Format? format,
  List<Field> filterList,
) {
  if (filterList.isNotEmpty) {
    final isJwtVpInJwtVCRequired = format?.jwtVp != null;

    final presentLdpVc = format?.ldpVc != null;
    final presentJwtVc = format?.jwtVc != null;

    if (isJwtVpInJwtVCRequired) {
      credentialList.removeWhere(
        (CredentialModel credentialModel) => credentialModel.jwt == null,
      );
    }

    /// remove ldp_vc
    if (presentJwtVc) {
      credentialList.removeWhere(
        (CredentialModel credentialModel) => credentialModel.jwt == null,
      );
    }

    /// remove jwt_vc
    if (presentLdpVc) {
      credentialList.removeWhere(
        (CredentialModel credentialModel) => credentialModel.jwt != null,
      );
    }
  }
  return credentialList;
}
