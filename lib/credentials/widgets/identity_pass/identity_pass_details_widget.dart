import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class IdentityPassDetailsWidget extends StatelessWidget {
  const IdentityPassDetailsWidget({Key? key, required this.identityPassModel})
      : super(key: key);

  final IdentityPassModel identityPassModel;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Column(
      children: [
        if (identityPassModel.expires != '')
          CredentialField(
            title: localizations.expires,
            value: identityPassModel.expires,
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.jobTitle != '')
          CredentialField(
            title: localizations.jobTitle,
            value: identityPassModel.recipient.jobTitle,
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.familyName != '')
          CredentialField(
            title: localizations.firstName,
            value: identityPassModel.recipient.familyName,
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.givenName != '')
          CredentialField(
            title: localizations.lastName,
            value: identityPassModel.recipient.givenName,
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.image != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: ImageFromNetwork(identityPassModel.recipient.image),
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.address != '')
          CredentialField(
            title: localizations.address,
            value: identityPassModel.recipient.address,
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.birthDate != '')
          CredentialField(
            title: localizations.birthdate,
            value: UIDate.displayDate(identityPassModel.recipient.birthDate),
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.email != '')
          CredentialField(
            title: localizations.personalMail,
            value: identityPassModel.recipient.email,
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.gender != '')
          CredentialField(
            title: localizations.gender,
            value: identityPassModel.recipient.gender,
          )
        else
          const SizedBox.shrink(),
        if (identityPassModel.recipient.telephone != '')
          CredentialField(
            title: localizations.personalPhone,
            value: identityPassModel.recipient.telephone,
          )
        else
          const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DisplayIssuer(
            issuer: identityPassModel.issuedBy,
          ),
        )
      ],
    );
  }
}
