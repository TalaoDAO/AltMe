import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TezoniaPassDisplayInList extends StatelessWidget {
  const TezoniaPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TezoniaPassView(credentialModel: credentialModel);
  }
}

class TezoniaPassDisplayInSelectionList extends StatelessWidget {
  const TezoniaPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TezoniaPassView(credentialModel: credentialModel);
  }
}

class TezoniaPassDisplayDetail extends StatelessWidget {
  const TezoniaPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TezoniaPassView(credentialModel: credentialModel),
      ],
    );
  }
}

class TezoniaPassView extends Recto {
  const TezoniaPassView({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final tezoniaPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as TezoniaPassModel;

    return const CredentialImage(
      image: ImageStrings.tezoniaPass,
      // child: AspectRatio(
      //   aspectRatio: Sizes.credentialAspectRatio,
      // ),
    );
  }
}
