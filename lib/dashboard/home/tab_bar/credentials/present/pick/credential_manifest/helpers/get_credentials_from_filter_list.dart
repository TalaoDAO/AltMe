import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromFilterList({
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
          final credentialData = createJsonByDecryptingSDValues(
            encryptedJson: credential.data,
            selectiveDisclosure: SelectiveDisclosure(credential),
          );

          final searchList = getTextsFromCredential(path, credentialData);
          if (searchList.isNotEmpty) {
            /// remove unmatched credential
            searchList.removeWhere(
              (searchParameter) {
                String? pattern;

                if (field.filter == null) {
                  //ascs case
                  return true;
                } else if (field.filter?.pattern != null) {
                  pattern = field.filter!.pattern;
                } else if (field.filter?.contains?.containsConst != null) {
                  pattern = field.filter?.contains?.containsConst;
                } else if (field.filter?.containsConst != null) {
                  pattern = field.filter?.containsConst;
                } else {
                  /// sd-jwt vc bool case
                  if (searchParameter == 'true') return false;
                }

                if (pattern == null) {
                  return true;
                } else if (pattern.endsWith(r'$')) {
                  final RegExp regEx = RegExp(pattern);
                  final Match? match = regEx.firstMatch(searchParameter);

                  if (match != null) return false;
                } else {
                  if (searchParameter == pattern) return false;
                }

                return true;
              },
            );
          }

          /// if [searchList] is not empty we mark this credential as
          /// a valid candidate
          if (searchList.isNotEmpty) {
            selectedCredential.add(credential);
          } else {
            break;
          }
        }
      }
    }
    return selectedCredential.toSet().toList();
  }
  return credentialList;
}
