import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ResidentCardWidget extends StatelessWidget {
  const ResidentCardWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final residentCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as ResidentCardModel;

    return CredentialBackground(
      credentialModel: credentialModel,
      child: Column(
        children: [
          DisplayIssuer(issuer: residentCardModel.issuedBy!),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CredentialField(
                title: l10n.lastName,
                value: residentCardModel.familyName!,
                showVertically: false,
              ),
              CredentialField(
                title: l10n.firstName,
                value: residentCardModel.givenName!,
                showVertically: false,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      '${l10n.gender}: ',
                      style: Theme.of(context).textTheme.credentialFieldTitle,
                    ),
                    Flexible(
                      child:
                          GenderDisplay(residentCardModel: residentCardModel),
                    ),
                  ],
                ),
              ),
              CredentialField(
                title: l10n.birthdate,
                value: UiDate.formatStringDate(residentCardModel.birthDate!),
                showVertically: false,
              ),
              CredentialField(
                title: l10n.birthplace,
                value: residentCardModel.birthPlace!,
                showVertically: false,
              ),
              CredentialField(
                title: l10n.address,
                value: residentCardModel.address!,
                showVertically: false,
              ),
              CredentialField(
                title: l10n.maritalStatus,
                value: residentCardModel.maritalStatus!,
                showVertically: false,
              ),
              CredentialField(
                title: l10n.identifier,
                value: residentCardModel.identifier!,
                showVertically: false,
              ),
              CredentialField(
                title: l10n.nationality,
                value: residentCardModel.nationality!,
                showVertically: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GenderDisplay extends StatelessWidget {
  const GenderDisplay({
    super.key,
    required this.residentCardModel,
  });

  final ResidentCardModel residentCardModel;

  @override
  Widget build(BuildContext context) {
    Widget genderIcon;
    switch (residentCardModel.gender) {
      case 'male':
        genderIcon =
            Icon(Icons.male, color: Theme.of(context).colorScheme.onSurface);
      case 'female':
        genderIcon =
            Icon(Icons.female, color: Theme.of(context).colorScheme.onSurface);
      default:
        genderIcon = Icon(
          Icons.transgender,
          color: Theme.of(context).colorScheme.onSurface,
        );
    }
    return genderIcon;
  }
}
