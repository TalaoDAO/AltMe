import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:oidc4vc/oidc4vc.dart';

List<CredentialModel> filterCredenialListByFormat({
  required VCFormatType vcFormatType,
  required Map<String, dynamic>? clientMetaData,
  required List<CredentialModel> credentialList,
  required PresentationDefinition presentationDefinition,
  required List<Field> filterList,
}) {
  final credentials = List<CredentialModel>.from(credentialList);
  if (filterList.isNotEmpty) {
    final supportingFormats = getPresentVCDetails(
      clientMetaData: clientMetaData,
      presentationDefinition: presentationDefinition,
      vcFormatType: vcFormatType,
      credentialsToBePresented: credentials,
    );
    credentials.removeWhere(
      (CredentialModel credentialModel) {
        /// we keep credential whose format are supported
        bool remove = true;
        for (final supportingFormat in supportingFormats) {
          if (credentialModel.getFormat == supportingFormat.vcValue) {
            remove = false;
          }
        }
        return remove;
      },
    );
  }
  return credentials;
}
