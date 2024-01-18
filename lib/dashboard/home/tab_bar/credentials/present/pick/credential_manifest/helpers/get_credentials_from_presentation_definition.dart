import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromPresentationDefinition({
  required PresentationDefinition presentationDefinition,
  required List<CredentialModel> credentialList,
  required int inputDescriptorIndex,
}) {
  final filterList = presentationDefinition
          .inputDescriptors[inputDescriptorIndex].constraints?.fields ??
      <Field>[];

  final isJwtVpInJwtVCRequired = presentationDefinition.format?.jwtVp != null;

  final presentLdpVc = presentationDefinition.format?.ldpVc != null;
  final presentJwtVc = presentationDefinition.format?.jwtVc != null;

  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  final filteredCredentialList = getCredentialsFromFilterList(
    filterList: filterList,
    credentialList: credentialList,
    isJwtVpInJwtVCRequired: isJwtVpInJwtVCRequired,
    presentLdpVc: presentLdpVc,
    presentJwtVc: presentJwtVc,
  );
  return filteredCredentialList;
}
