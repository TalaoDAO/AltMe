import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DefaultPolygonIdCardWidget extends StatelessWidget {
  const DefaultPolygonIdCardWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final DisplayMapping? titleDisplayMapping = credentialModel
        .credentialManifest!.outputDescriptors?.first.display?.title;

    var title = '';

    if (titleDisplayMapping is DisplayMappingText) {
      title = titleDisplayMapping.text;
    }

    if (titleDisplayMapping is DisplayMappingPath) {
      if (titleDisplayMapping.path.isNotEmpty) {
        title = getTextsFromCredential(
          titleDisplayMapping.path.first,
          credentialModel.data,
        ).first;
      }
      if (title == '') {
        title = titleDisplayMapping.fallback ?? '';
      } else {
        final regex = RegExp('(?=[A-Z](?![A-Z]))');
        title = title.replaceAll(regex, ' ');
      }
    }

    final DisplayMapping? subTitleDisplayMapping = credentialModel
        .credentialManifest?.outputDescriptors?.first.display?.subtitle;

    var subTitle = '';

    if (subTitleDisplayMapping is DisplayMappingText) {
      subTitle = subTitleDisplayMapping.text;
    }

    if (subTitleDisplayMapping is DisplayMappingPath) {
      subTitle = subTitleDisplayMapping.fallback ?? '';
    }

    return CredentialBaseWidget(
      title: title,
      cardBackgroundImagePath: ImageStrings.defaultCard,
      issuerName: credentialModel.credentialManifest?.issuedBy?.name,
      value: subTitle,
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(credentialModel.expirationDate!),
    );
  }
}
