import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PhonePassDisplayInList extends StatelessWidget {
  const PhonePassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInList(
      credentialModel: credentialModel,
    );
  }
}

class PhonePassDisplayInSelectionList extends StatelessWidget {
  const PhonePassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInSelectionList(
      credentialModel: credentialModel,
    );
  }
}

class PhonePassDisplayDetail extends StatelessWidget {
  const PhonePassDisplayDetail({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final phonePassModel = credentialModel
        .credentialPreview.credentialSubjectModel as PhonePassModel;

    return CredentialBackground(
      model: credentialModel,
      child: Column(
        children: [
          CredentialField(
            title: l10n.personalPhone,
            value: phonePassModel.phone!,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DisplayIssuer(
              issuer: phonePassModel.issuedBy!,
            ),
          ),
        ],
      ),
    );
  }
}
