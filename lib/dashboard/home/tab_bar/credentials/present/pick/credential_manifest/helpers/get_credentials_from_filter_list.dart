import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromFilterList({
  required List<Field> filterList,
  required List<CredentialModel> credentialList,
  required bool? isJwtVpInJwtVCRequired,
}) {
  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  if (filterList.isNotEmpty) {
    final selectedCredential = <CredentialModel>[];

    /// remove ldp_vp if jwt_vp is required
    if (isJwtVpInJwtVCRequired != null && isJwtVpInJwtVCRequired) {
      credentialList.removeWhere(
        (CredentialModel credentialModel) => credentialModel.jwt == null,
      );
    }

    for (final field in filterList) {
      for (final credential in credentialList) {
        for (final path in field.path) {
          final searchList = getTextsFromCredential(path, credential.data);
          if (searchList.isNotEmpty) {
            /// remove unmatched credential
            searchList.removeWhere(
              (element) {
                if (field.filter?.pattern != null &&
                    element == field.filter?.pattern) {
                  return false;
                } else if (field.filter?.contains != null &&
                    element == field.filter?.contains?.containsConst) {
                  return false;
                }

                return true;
              },
            );
          }

          /// if [searchList] is not empty we mark this credential as
          /// a valid candidate
          if (searchList.isNotEmpty) {
            selectedCredential.add(credential);
          }
        }
      }
    }

    return selectedCredential;
  }
  return credentialList;
}
