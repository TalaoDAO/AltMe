import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromPresentationDefinition({
  required PresentationDefinition presentationDefinition,
  required List<CredentialModel> credentialList,
  required int inputDescriptorIndex,
  required bool? isJwtVpInJwtVCRequired,
}) {
  final allInputDescriptorConsidered =
      presentationDefinition.submissionRequirements != null;

  var filterList = <Field>[];

  if (allInputDescriptorConsidered) {
    for (final descriptor in presentationDefinition.inputDescriptors) {
      if (descriptor.constraints != null &&
          descriptor.constraints!.fields != null) {
        for (final field in descriptor.constraints!.fields!) {
          filterList.add(field);
        }
      }
    }
  } else {
    filterList = presentationDefinition
            .inputDescriptors[inputDescriptorIndex].constraints?.fields ??
        <Field>[];
  }

  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  final filteredCredentialList = getCredentialsFromFilterList(
    filterList: filterList,
    credentialList: credentialList,
    isJwtVpInJwtVCRequired: isJwtVpInJwtVCRequired,
  );
  return filteredCredentialList;
}
