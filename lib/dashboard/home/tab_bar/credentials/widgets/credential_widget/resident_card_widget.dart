import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ResidentCardWidget extends StatelessWidget {
  const ResidentCardWidget({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

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
              ),
              CredentialField(
                title: l10n.firstName,
                value: residentCardModel.givenName!,
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
              ),
              CredentialField(
                title: l10n.birthplace,
                value: residentCardModel.birthPlace!,
              ),
              CredentialField(
                title: l10n.address,
                value: residentCardModel.address!,
              ),
              CredentialField(
                title: l10n.maritalStatus,
                value: residentCardModel.maritalStatus!,
              ),
              CredentialField(
                title: l10n.identifier,
                value: residentCardModel.identifier!,
              ),
              CredentialField(
                title: l10n.nationality,
                value: residentCardModel.nationality!,
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
    Key? key,
    required this.residentCardModel,
  }) : super(key: key);

  final ResidentCardModel residentCardModel;

  @override
  Widget build(BuildContext context) {
    Widget _genderIcon;
    switch (residentCardModel.gender) {
      case 'male':
        _genderIcon =
            Icon(Icons.male, color: Theme.of(context).colorScheme.genderIcon);
        break;
      case 'female':
        _genderIcon =
            Icon(Icons.female, color: Theme.of(context).colorScheme.genderIcon);
        break;
      default:
        _genderIcon = Icon(
          Icons.transgender,
          color: Theme.of(context).colorScheme.genderIcon,
        );
    }
    return _genderIcon;
  }
}
