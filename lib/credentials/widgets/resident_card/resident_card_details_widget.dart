import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ResidentCardDetailsWidget extends StatelessWidget {
  const ResidentCardDetailsWidget({Key? key, required this.model})
      : super(key: key);

  final ResidentCardModel model;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Column(
      children: [
        DisplayIssuer(issuer: model.issuedBy),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CredentialField(
                title: localizations.lastName, value: model.familyName),
            CredentialField(
                title: localizations.firstName, value: model.givenName),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    '${localizations.gender}: ',
                    style: Theme.of(context).textTheme.credentialFieldTitle,
                  ),
                  Flexible(
                    child: genderDisplay(context),
                  ),
                ],
              ),
            ),
            CredentialField(
                title: localizations.birthdate,
                value: UIDate.displayDate(model.birthDate)),
            CredentialField(
              title: localizations.birthplace,
              value: model.birthPlace,
            ),
            CredentialField(title: localizations.address, value: model.address),
            CredentialField(
              title: localizations.maritalStatus,
              value: model.maritalStatus,
            ),
            CredentialField(
              title: localizations.identifier,
              value: model.identifier,
            ),
            CredentialField(
              title: localizations.nationality,
              value: model.nationality,
            ),
          ],
        ),
      ],
    );
  }

  Widget genderDisplay(BuildContext context) {
    Widget _genderIcon;
    switch (model.gender) {
      case 'male':
        _genderIcon =
            Icon(Icons.male, color: Theme.of(context).colorScheme.genderIcon);
        break;
      case 'female':
        _genderIcon =
            Icon(Icons.female, color: Theme.of(context).colorScheme.genderIcon);
        break;
      default:
        _genderIcon = Icon(Icons.transgender,
            color: Theme.of(context).colorScheme.genderIcon);
    }
    return _genderIcon;
  }
}
