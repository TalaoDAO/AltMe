import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromPresentationDefinition({
  required Map<String, dynamic> presentationDefinition,
  required List<CredentialModel> credentialList,
  required int inputDescriptorIndex,
}) {
  /// Get instruction to filter credentials of the wallet
  final claims = PresentationDefinition.fromJson(presentationDefinition);
  final filterList =
      claims.inputDescriptors[inputDescriptorIndex].constraints?.fields ??
          <Field>[];

  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  final filteredCredentialList =
      getCredentialsFromFilterList(filterList, credentialList);
  return filteredCredentialList;
}
