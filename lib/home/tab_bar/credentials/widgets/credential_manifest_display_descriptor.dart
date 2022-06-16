import 'package:altme/home/home.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CredentialManifestDisplayDescriptor extends StatelessWidget {
  const CredentialManifestDisplayDescriptor({
    Key? key,
    required this.credentialModel,
    required this.outputDescriptor,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final OutputDescriptor outputDescriptor;

  @override
  Widget build(BuildContext context) {
    final textColor =
        getColorFromCredential(outputDescriptor.styles?.text, Colors.black);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (outputDescriptor.display?.title != null)
                DisplayTitleWidget(
                  displayMapping: outputDescriptor.display?.title,
                  credentialModel: credentialModel,
                  textColor: textColor,
                )
              else
                const Text(''),
              DisplayDescriptionWidget(
                displayMapping: outputDescriptor.display?.description,
                credentialModel: credentialModel,
                textColor: textColor,
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: DisplayIssuanceDateWidget(
            issuanceDate: credentialModel.credentialPreview.issuanceDate,
            textColor: textColor,
          ),
        )
      ],
    );
  }
}
