import 'package:altme/app/shared/shared.dart';
import 'package:altme/credentials/models/model.dart';
import 'package:altme/credentials/widgets/display_issuer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CertificateOfEmploymentWidget extends StatelessWidget {
  const CertificateOfEmploymentWidget({Key? key, required this.model})
      : super(key: key);

  final CertificateOfEmploymentModel model;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations il0n = context.l10n;
    return Column(
      children: [
        CredentialField(title: il0n.firstName, value: model.familyName),
        CredentialField(title: il0n.lastName, value: model.givenName),
        CredentialField(title: il0n.jobTitle, value: model.jobTitle),
        if (model.workFor.name != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${il0n.workFor}: ',
                  style: Theme.of(context).textTheme.credentialFieldTitle,
                ),
                Text(
                  model.workFor.name,
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
                const Spacer(),
                if (model.workFor.logo != '')
                  SizedBox(
                    height: 30,
                    child: ImageFromNetwork(model.workFor.logo),
                  )
                else
                  const SizedBox.shrink()
              ],
            ),
          )
        else
          const SizedBox.shrink(),
        CredentialField(
          title: il0n.startDate,
          value: UiDate.displayDate(il0n, model.startDate),
        ),
        CredentialField(
          title: il0n.employmentType,
          value: model.employmentType,
        ),
        CredentialField(title: il0n.baseSalary, value: model.baseSalary),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DisplayIssuer(issuer: model.issuedBy),
        )
      ],
    );
  }
}
