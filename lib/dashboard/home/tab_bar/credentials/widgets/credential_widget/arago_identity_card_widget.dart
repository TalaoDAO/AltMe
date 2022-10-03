import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/identity_credential_base_widget.dart';
import 'package:flutter/material.dart';

class AragoIdentityCardDisplayInList extends StatelessWidget {
  const AragoIdentityCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoIdentityCardRecto(credentialModel: credentialModel);
  }
}

class AragoIdentityCardDisplayInSelectionList extends StatelessWidget {
  const AragoIdentityCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoIdentityCardRecto(credentialModel: credentialModel);
  }
}

class AragoIdentityCardDisplayDetail extends StatelessWidget {
  const AragoIdentityCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoIdentityCardRecto(credentialModel: credentialModel);
  }
}

class AragoIdentityCardRecto extends StatelessWidget {
  const AragoIdentityCardRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const IdentityCredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.aragoIdentityCard,
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
