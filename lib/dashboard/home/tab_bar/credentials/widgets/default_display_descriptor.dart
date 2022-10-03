import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/theme/theme.dart';
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
    final credential = Credential.fromJsonOrDummy(credentialModel.data);
    return FractionallySizedBox(
      widthFactor: 0.95,
      heightFactor: 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CredentialIcon(
                        iconData: credential
                            .credentialSubjectModel.credentialSubjectType
                            .iconData(),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: DisplayNameCard(
                          credentialModel: credentialModel,
                          style: Theme.of(context).textTheme.credentialTitle,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: DisplayDescriptionCard(
                      credentialModel: credentialModel,
                      style: Theme.of(context).textTheme.credentialDescription,
                      maxLines: descriptionMaxLine,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: DisplayIssuer(
              issuer: credentialModel
                  .credentialPreview.credentialSubjectModel.issuedBy!,
            ),
          )
        ],
      ),
    );
  }
}
