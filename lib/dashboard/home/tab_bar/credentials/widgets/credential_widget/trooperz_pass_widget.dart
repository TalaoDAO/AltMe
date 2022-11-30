import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TrooperzPassDisplayInList extends StatelessWidget {
  const TrooperzPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TrooperzPassView(credentialModel: credentialModel);
  }
}

class TrooperzPassDisplayInSelectionList extends StatelessWidget {
  const TrooperzPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TrooperzPassView(credentialModel: credentialModel);
  }
}

class TrooperzPassDisplayDetail extends StatelessWidget {
  const TrooperzPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TrooperzPassView(credentialModel: credentialModel),
      ],
    );
  }
}

class TrooperzPassView extends Recto {
  const TrooperzPassView({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final trooperzPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as TrooperzPassModel;

    return const CredentialImage(
      image: ImageStrings.trooperzPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
