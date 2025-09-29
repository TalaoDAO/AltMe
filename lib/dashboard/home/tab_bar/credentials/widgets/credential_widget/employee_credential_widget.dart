import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class EmployeeCredentialWidget extends StatelessWidget {
  const EmployeeCredentialWidget({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final employeeCredentialModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as EmployeeCredentialModel;

    final DisplayMapping? titleDisplayMapping = credentialModel
        .credentialManifest
        ?.outputDescriptors
        ?.first
        .display
        ?.title;

    var title = '';

    if (titleDisplayMapping is DisplayMappingText) {
      title = titleDisplayMapping.text;
    }

    if (titleDisplayMapping is DisplayMappingPath) {
      title = titleDisplayMapping.fallback ?? '';
    }

    if (title == '') {
      title = credentialModel
          .credentialPreview
          .credentialSubjectModel
          .credentialSubjectType
          .title;
    }

    final DisplayMapping? subTitleDisplayMapping = credentialModel
        .credentialManifest
        ?.outputDescriptors
        ?.first
        .display
        ?.subtitle;

    var subTitle = '';

    if (subTitleDisplayMapping is DisplayMappingText) {
      subTitle = subTitleDisplayMapping.text;
    }

    if (subTitleDisplayMapping is DisplayMappingPath) {
      subTitle = subTitleDisplayMapping.fallback ?? '';
    }

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.employeeCard,
      issuerName: credentialModel
          .credentialPreview
          .credentialSubjectModel
          .issuedBy
          ?.name,
      value: subTitle,
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      title: title,
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(credentialModel.expirationDate!),
    );
  }
}
