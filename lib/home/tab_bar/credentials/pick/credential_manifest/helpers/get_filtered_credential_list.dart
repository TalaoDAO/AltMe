import 'package:altme/home/tab_bar/credentials/credential.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getFilteredCredentialList(
  Map<String, dynamic> presentationDefinition,
  List<CredentialModel> credentialList,
) {
  /// Get instruction to filter credentials of the wallet
  final claims = PresentationDefinition.fromJson(presentationDefinition);
  final filterList =
      claims.inputDescriptors.first.constraints?.fields ?? <Field>[];

  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  if (filterList.isNotEmpty) {
    /// Filter the list of credentials
    credentialList.removeWhere((credential) {
      /// A credential must satisfy each field to be candidate for presentation
      var isPresentationCandidate = true;
      for (final field in filterList) {
        /// A credential must statisfy at least one path and
        /// match pattern to be selected
        var isFieldCandidate = false;
        for (final path in field.path) {
          final searchList = getTextsFromCredential(path, credential.data);
          if (searchList.isNotEmpty) {
            /// I remove credential not
            searchList.removeWhere(
              (element) {
                if (element == field.filter?.pattern) {
                  return false;
                }
                return true;
              },
            );

            /// if [searchList] is not empty we mark this credential as
            /// a valid candidate
            if (searchList.isNotEmpty) {
              isFieldCandidate = true;
            }
          }
        }

        /// A credential must satisfy each field to be candidate
        /// for presentation
        /// So, if one field condition is not satisfied
        /// the current credential is not a candidate for presentation
        if (isFieldCandidate == false) {
          isPresentationCandidate = false;
        }
      }

      /// Remove non candidate credential from the list
      return !isPresentationCandidate;
    });
  }
  return credentialList;
}
