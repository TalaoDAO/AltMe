import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class PigsPassDisplayInList extends StatelessWidget {
  const PigsPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return PigsPassView(credentialModel: credentialModel);
  }
}

class PigsPassDisplayInSelectionList extends StatelessWidget {
  const PigsPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return PigsPassView(credentialModel: credentialModel);
  }
}

class PigsPassDisplayDetail extends StatelessWidget {
  const PigsPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PigsPassView(credentialModel: credentialModel),
      ],
    );
  }
}

class PigsPassView extends Recto {
  const PigsPassView({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final pigsPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as PigsPassModel;

    return const CredentialImage(
      image: ImageStrings.pigsPass,
      // child: AspectRatio(
      //   aspectRatio: Sizes.credentialAspectRatio,
      // ),
    );
  }
}
