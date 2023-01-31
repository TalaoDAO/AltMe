import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CredentialManifestCard extends StatelessWidget {
  const CredentialManifestCard({
    super.key,
    required this.credentialModel,
    required this.outputDescriptor,
  });

  final CredentialModel credentialModel;
  final OutputDescriptor outputDescriptor;

  @override
  Widget build(BuildContext context) {
    final textColor =
        getColorFromCredential(outputDescriptor.styles?.text, Colors.black);
    final credential = Credential.fromJsonOrDummy(credentialModel.data);
    return FractionallySizedBox(
      widthFactor: 0.85,
      heightFactor: 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CredentialIcon(
                      iconData: credential.credentialSubjectModel
                          .credentialSubjectType.iconData,
                      color: textColor,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: outputDescriptor.display?.title != null
                          ? DisplayTitleWidget(
                              displayMapping: outputDescriptor.display?.title,
                              credentialModel: credentialModel,
                              textColor: textColor,
                            )
                          : const Text(''),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: DisplayTitleWidget(
                    displayMapping: outputDescriptor.display?.subtitle,
                    credentialModel: credentialModel,
                    textColor: textColor,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 1,
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: DisplayIssuanceDateWidget(
                issuanceDate: credentialModel.credentialPreview.issuanceDate,
                textColor: textColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
