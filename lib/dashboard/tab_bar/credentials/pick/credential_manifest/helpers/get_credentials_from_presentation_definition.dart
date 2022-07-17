import 'package:altme/dashboard/tab_bar/credentials/credential.dart';
import 'package:altme/dashboard/tab_bar/credentials/pick/credential_manifest/helpers/get_credentials_from_filter_list.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromPresentationDefinition(
  Map<String, dynamic> presentationDefinition,
  List<CredentialModel> credentialList,
) {
  /// Get instruction to filter credentials of the wallet
  final claims = PresentationDefinition.fromJson(presentationDefinition);
  final filterList =
      claims.inputDescriptors.first.constraints?.fields ?? <Field>[];

  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  final filteredCredentialList =
      getCredentialsFromFilterList(filterList, credentialList);
  return filteredCredentialList;
}
