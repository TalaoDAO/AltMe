import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/credential_manifest/helpers/filter_credential_list_by_format.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromPresentationDefinition({
  required PresentationDefinition presentationDefinition,
  required List<CredentialModel> credentialList,
  required int inputDescriptorIndex,
}) {
  final filterList = presentationDefinition
          .inputDescriptors[inputDescriptorIndex].constraints?.fields ??
      <Field>[];

  final credentialListFilteredByFormat = filterCredenialListByFormat(
    List.from(credentialList),
    presentationDefinition.format,
    filterList,
  );

  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  final filteredCredentialList = getCredentialsFromFilterList(
    filterList: filterList,
    credentialList: List.from(credentialListFilteredByFormat),
  );
  return filteredCredentialList;
}
