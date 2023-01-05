import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class SelfIssuedWidget extends StatelessWidget {
  const SelfIssuedWidget({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final selfIssuedModel = credentialModel
        .credentialPreview.credentialSubjectModel as SelfIssuedModel;

    return CredentialBackground(
      credentialModel: credentialModel,
      child: Column(
        children: [
          if (selfIssuedModel.givenName?.isNotEmpty ?? false)
            CredentialField(
              title: l10n.firstName,
              value: selfIssuedModel.givenName!,
            )
          else
            const SizedBox.shrink(),
          if (selfIssuedModel.familyName?.isNotEmpty ?? false)
            CredentialField(
              title: l10n.lastName,
              value: selfIssuedModel.familyName!,
            )
          else
            const SizedBox.shrink(),
          if (selfIssuedModel.telephone?.isNotEmpty ?? false)
            CredentialField(
              title: l10n.personalPhone,
              value: selfIssuedModel.telephone!,
            )
          else
            const SizedBox.shrink(),
          if (selfIssuedModel.address?.isNotEmpty ?? false)
            CredentialField(
              title: l10n.address,
              value: selfIssuedModel.address!,
            )
          else
            const SizedBox.shrink(),
          if (selfIssuedModel.email?.isNotEmpty ?? false)
            CredentialField(
              title: l10n.personalMail,
              value: selfIssuedModel.email!,
            )
          else
            const SizedBox.shrink(),
          if (selfIssuedModel.workFor?.isNotEmpty ?? false)
            CredentialField(
              title: l10n.companyName,
              value: selfIssuedModel.workFor!,
            )
          else
            const SizedBox.shrink(),
          if (selfIssuedModel.companyWebsite?.isNotEmpty ?? false)
            CredentialField(
              title: l10n.companyWebsite,
              value: selfIssuedModel.companyWebsite!,
            )
          else
            const SizedBox.shrink(),
          if (selfIssuedModel.jobTitle?.isNotEmpty ?? false)
            CredentialField(
              title: l10n.jobTitle,
              value: selfIssuedModel.jobTitle!,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
