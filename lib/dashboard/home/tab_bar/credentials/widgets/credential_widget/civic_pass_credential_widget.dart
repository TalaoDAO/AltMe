import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CivicPassCredentialWidget extends StatelessWidget {
  const CivicPassCredentialWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final civicPassCredentialModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as CivicPassCredentialModel;

    final DisplayMapping? displayMapping = credentialModel
        .credentialManifest!.outputDescriptors?.first.display?.title;

    var title = '';

    if (displayMapping is DisplayMappingText) {
      title = displayMapping.text;
    }

    if (displayMapping is DisplayMappingPath) {
      title = displayMapping.fallback ?? '';
    }

    return CredentialBaseWidget(
      title: title,
      cardBackgroundImagePath: ImageStrings.civicPassCard,
      issuerName: 'CIVIC',
      value: 'Your ID is verified',
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(credentialModel.expirationDate!),
    );
  }
}
