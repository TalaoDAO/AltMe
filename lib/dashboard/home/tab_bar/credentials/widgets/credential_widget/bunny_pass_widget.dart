import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class BunnyPassDisplayInList extends StatelessWidget {
  const BunnyPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return BunnyPassView(credentialModel: credentialModel);
  }
}

class BunnyPassDisplayInSelectionList extends StatelessWidget {
  const BunnyPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return BunnyPassView(credentialModel: credentialModel);
  }
}

class BunnyPassDisplayDetail extends StatelessWidget {
  const BunnyPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BunnyPassView(credentialModel: credentialModel),
      ],
    );
  }
}

class BunnyPassView extends Recto {
  const BunnyPassView({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final bunnyPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as BunnyPassModel;

    return const CredentialImage(
      image: ImageStrings.bunnyPass,
      // child: AspectRatio(
      //   aspectRatio: Sizes.credentialAspectRatio,
      // ),
    );
  }
}
