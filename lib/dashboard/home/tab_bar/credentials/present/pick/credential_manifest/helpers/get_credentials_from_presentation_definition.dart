import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromPresentationDefinition({
  required PresentationDefinition presentationDefinition,
  required List<CredentialModel> credentialList,
  required int inputDescriptorIndex,
  required bool? isJwtVpInJwtVCRequired,
}) {
  final filterList = presentationDefinition
          .inputDescriptors[inputDescriptorIndex].constraints?.fields ??
      <Field>[];

  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  final filteredCredentialList = getCredentialsFromFilterList(
    filterList: filterList,
    credentialList: credentialList,
    isJwtVpInJwtVCRequired: isJwtVpInJwtVCRequired,
  );
  return filteredCredentialList;
}
