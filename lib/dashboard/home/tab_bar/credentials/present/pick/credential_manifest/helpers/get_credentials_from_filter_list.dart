import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel>  getCredentialsFromFilterList({
  required List<Field> filterList,
  required List<CredentialModel> credentialList,
}) {
  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  if (filterList.isNotEmpty) {
    /// remove ldp_vp if jwt_vp is required

    final selectedCredential = <CredentialModel>[];
    for (final field in filterList) {
      for (final credential in credentialList) {
        for (final path in field.path) {
          final searchList = getTextsFromCredential(path, credential.data);
          if (searchList.isNotEmpty) {
            /// remove unmatched credential
            searchList.removeWhere(
              (element) {
                String? pattern;

                if (field.filter?.pattern != null) {
                  pattern = field.filter!.pattern;
                } else if (field.filter?.contains?.containsConst != null) {
                  pattern = field.filter?.contains?.containsConst;
                }

                if (pattern == null) return true;

                if (pattern.endsWith(r'$')) {
                  final RegExp regEx = RegExp(pattern);
                  final Match? match = regEx.firstMatch(element);

                  if (match != null) return false;
                } else {
                  if (element == pattern) return false;
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
