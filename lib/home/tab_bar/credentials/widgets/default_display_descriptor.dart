import 'package:altme/home/home.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DefaultDisplayDescriptor extends StatelessWidget {
  const DefaultDisplayDescriptor({
    Key? key,
    required this.credentialModel,
    required this.descriptionMaxLine,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final int descriptionMaxLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DisplayNameCard(
                credentialModel: credentialModel,
                style: Theme.of(context).textTheme.credentialTitle,
              ),
              const SizedBox(height: 5),
              DisplayDescriptionCard(
                credentialModel: credentialModel,
                style: Theme.of(context).textTheme.credentialDescription,
                maxLines: descriptionMaxLine,
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: FractionallySizedBox(
            heightFactor: 0.4,
            child: DisplayIssuer(
              issuer: credentialModel
                  .credentialPreview.credentialSubjectModel.issuedBy!,
            ),
          ),
        )
      ],
    );
  }
}
