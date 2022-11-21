import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DogamiPassDisplayInList extends StatelessWidget {
  const DogamiPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DogamiPassView(credentialModel: credentialModel);
  }
}

class DogamiPassDisplayInSelectionList extends StatelessWidget {
  const DogamiPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DogamiPassView(credentialModel: credentialModel);
  }
}

class DogamiPassDisplayDetail extends StatelessWidget {
  const DogamiPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DogamiPassView(credentialModel: credentialModel),
      ],
    );
  }
}

class DogamiPassView extends Recto {
  const DogamiPassView({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final dogamiPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as DogamiPassModel;

    return const CredentialImage(
      image: ImageStrings.dogamiPass,
      // child: AspectRatio(
      //   aspectRatio: Sizes.credentialAspectRatio,
      // ),
    );
  }
}
