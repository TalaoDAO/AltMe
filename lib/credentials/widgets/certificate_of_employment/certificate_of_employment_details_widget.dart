import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CertificateOfEmploymentDetailsWidget extends StatelessWidget {
  final CertificateOfEmploymentModel model;

  const CertificateOfEmploymentDetailsWidget({Key? key, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Column(
      children: [
        CredentialField(
            title: localizations.firstName, value: model.familyName),
        CredentialField(title: localizations.lastName, value: model.givenName),
        CredentialField(title: localizations.jobTitle, value: model.jobTitle),
        if (model.workFor.name != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text('${localizations.workFor}: ',
                    style: Theme.of(context).textTheme.credentialFieldTitle),
                Text(
                  model.workFor.name,
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
                const Spacer(),
                if (model.workFor.logo != '')
                  SizedBox(
                      height: 30, child: ImageFromNetwork(model.workFor.logo))
                else
                  const SizedBox.shrink()
              ],
            ),
          )
        else
          const SizedBox.shrink(),
        CredentialField(
            title: localizations.startDate,
            value: UIDate.displayDate(model.startDate)),
        CredentialField(
            value: model.employmentType, title: localizations.employmentType),
        CredentialField(
            title: localizations.baseSalary, value: model.baseSalary),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DisplayIssuer(
            issuer: model.issuedBy,
          ),
        )
      ],
    );
  }
}
