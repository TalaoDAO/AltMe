import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/credential_manifest/helpers/filter_credential_list_by_format.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:oidc4vc/oidc4vc.dart';

List<CredentialModel> getCredentialsFromPresentationDefinition({
  required VCFormatType vcFormatType,
  required PresentationDefinition presentationDefinition,
  required Map<String, dynamic>? clientMetaData,
  required List<CredentialModel> credentialList,
  required int inputDescriptorIndex,
}) {
  final filterList = presentationDefinition
          .inputDescriptors[inputDescriptorIndex].constraints?.fields ??
      <Field>[];

  final credentialListFilteredByFormat = filterCredenialListByFormat(
    credentialList: List.from(credentialList),
    presentationDefinition: presentationDefinition,
    filterList: filterList,
    clientMetaData: clientMetaData,
    vcFormatType: vcFormatType,
  );

  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  final filteredCredentialList = getCredentialsFromFilterList(
    filterList: filterList,
    credentialList: List.from(credentialListFilteredByFormat),
  );
  return filteredCredentialList;
}
