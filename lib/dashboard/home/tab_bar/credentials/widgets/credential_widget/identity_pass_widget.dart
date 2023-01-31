import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class IdentityPassWidget extends StatelessWidget {
  const IdentityPassWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final identityPassModel = credentialModel
        .credentialPreview.credentialSubjectModel as IdentityPassModel;
    return CredentialBackground(
      credentialModel: credentialModel,
      child: Column(
        children: [
          if (identityPassModel.expires != '')
            CredentialField(
              title: l10n.expires,
              value: identityPassModel.expires!,
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.jobTitle != '')
            CredentialField(
              title: l10n.jobTitle,
              value: identityPassModel.recipient!.jobTitle,
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.familyName != '')
            CredentialField(
              title: l10n.firstName,
              value: identityPassModel.recipient!.familyName,
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.givenName != '')
            CredentialField(
              title: l10n.lastName,
              value: identityPassModel.recipient!.givenName,
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.image != '')
            Padding(
              padding: const EdgeInsets.all(8),
              child: CachedImageFromNetwork(identityPassModel.recipient!.image),
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.address != '')
            CredentialField(
              title: l10n.address,
              value: identityPassModel.recipient!.address,
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.birthDate != '')
            CredentialField(
              title: l10n.birthdate,
              value: UiDate.formatStringDate(
                identityPassModel.recipient!.birthDate,
              ),
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.email != '')
            CredentialField(
              title: l10n.personalMail,
              value: identityPassModel.recipient!.email,
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.gender != '')
            CredentialField(
              title: l10n.gender,
              value: identityPassModel.recipient!.gender,
            )
          else
            const SizedBox.shrink(),
          if (identityPassModel.recipient!.telephone != '')
            CredentialField(
              title: l10n.personalPhone,
              value: identityPassModel.recipient!.telephone,
            )
          else
            const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 40,
              child: DisplayIssuer(
                issuer: identityPassModel.issuedBy!,
              ),
            ),
          )
        ],
      ),
    );
  }
}
