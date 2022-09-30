import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TalaoCommunityCardDisplayInList extends StatelessWidget {
  const TalaoCommunityCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TalaoCommunityCardRecto(credentialModel: credentialModel);
  }
}

class TalaoCommunityCardDisplayInSelectionList extends StatelessWidget {
  const TalaoCommunityCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TalaoCommunityCardRecto(credentialModel: credentialModel);
  }
}

class TalaoCommunityCardDisplayDetail extends StatelessWidget {
  const TalaoCommunityCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TalaoCommunityCardRecto(credentialModel: credentialModel);
  }
}

class TalaoCommunityCardRecto extends Recto {
  const TalaoCommunityCardRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final talaoCommunityCardModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as TalaoCommunityCardModel;

    return CredentialImage(
      image: ImageStrings.talaoCommunityCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: Container(),
      ),
    );
  }
}
