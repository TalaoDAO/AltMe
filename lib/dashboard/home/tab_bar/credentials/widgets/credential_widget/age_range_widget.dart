import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class AgeRangeDisplayInList extends StatelessWidget {
  const AgeRangeDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AgeRangeRecto(credentialModel: credentialModel);
  }
}

class AgeRangeDisplayInSelectionList extends StatelessWidget {
  const AgeRangeDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AgeRangeRecto(credentialModel: credentialModel);
  }
}

class AgeRangeDisplayDetail extends StatelessWidget {
  const AgeRangeDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgeRangeRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class AgeRangeRecto extends Recto {
  const AgeRangeRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final ageRangeModel = credentialModel
        .credentialPreview.credentialSubjectModel as AgeRangeModel;

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.ageRangeProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value:
          (ageRangeModel.ageRange != null && ageRangeModel.ageRange!.isNotEmpty)
              ? '${ageRangeModel.ageRange} YO'
              : '--',
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(
              credentialModel.expirationDate!,
            ),
    );
  }
}
