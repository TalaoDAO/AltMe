import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/widgets/credential_widget/identity_credential_base_widget.dart';
import 'package:flutter/material.dart';

class IdentityCardDisplayInList extends StatelessWidget {
  const IdentityCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return IdentityCardRecto(credentialModel: credentialModel);
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
    return IdentityCardRecto(credentialModel: credentialModel);
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
    return IdentityCardRecto(credentialModel: credentialModel);
  }
}

class IdentityCardRecto extends StatelessWidget {
  const IdentityCardRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final identityCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as IdentityCardModel;

    return const IdentityCredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.identityCard,
      // issuerName: credentialModel
      //     .credentialPreview.credentialSubjectModel.issuedBy?.name,
      // value: '${identityCardModel.givenName}'
      //     ' ${identityCardModel.familyName}',
      // issuanceDate: UiDate.formatDateForCredentialCard(
      //   credentialModel.credentialPreview.issuanceDate,
      // ),
      expirationDate: '--',
    );
  }
}
