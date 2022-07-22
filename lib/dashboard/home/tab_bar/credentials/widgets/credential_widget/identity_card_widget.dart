import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class IdentityCardDisplayInList extends StatelessWidget {
  const IdentityCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInList(
      credentialModel: credentialModel,
      descriptionMaxLine: 4,
    );
  }
}

class IdentityCardDisplayInSelectionList extends StatelessWidget {
  const IdentityCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInSelectionList(
      credentialModel: credentialModel,
      descriptionMaxLine: 4,
    );
  }
}

class IdentityCardDisplayDetail extends StatelessWidget {
  const IdentityCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final identityCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as IdentityCardModel;
    return CredentialBackground(
      credentialModel: credentialModel,
      child: Column(
        children: [
          if (identityCardModel.familyName != '')
            CredentialField(
              title: l10n.firstName,
              value: identityCardModel.familyName!,
            )
          else
            const SizedBox.shrink(),
          if (identityCardModel.givenName != '')
            CredentialField(
              title: l10n.lastName,
              value: identityCardModel.givenName!,
            )
          else
            const SizedBox.shrink(),
          if (identityCardModel.birthDate != '')
            CredentialField(
              title: l10n.birthdate,
              value: identityCardModel.birthDate!,
            )
          else
            const SizedBox.shrink(),
          if (identityCardModel.bithPlace != '')
            CredentialField(
              title: l10n.birthplace,
              value: identityCardModel.bithPlace!,
            )
          else
            const SizedBox.shrink(),
          if (identityCardModel.addressCountry != '')
            CredentialField(
              title: l10n.address,
              value: identityCardModel.addressCountry!,
            )
          else
            const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 40,
              child: DisplayIssuer(
                issuer: identityCardModel.issuedBy!,
              ),
            ),
          )
        ],
      ),
    );
  }
}
