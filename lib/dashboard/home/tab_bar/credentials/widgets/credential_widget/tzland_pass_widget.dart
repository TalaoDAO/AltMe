import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TzlandPassDisplayInList extends StatelessWidget {
  const TzlandPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TzlandPassView(credentialModel: credentialModel);
  }
}

class TzlandPassDisplayInSelectionList extends StatelessWidget {
  const TzlandPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return TzlandPassView(credentialModel: credentialModel);
  }
}

class TzlandPassDisplayDetail extends StatelessWidget {
  const TzlandPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TzlandPassView(credentialModel: credentialModel),
      ],
    );
  }
}

class TzlandPassView extends Recto {
  const TzlandPassView({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final tzlandPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as TzlandPassModel;

    return const CredentialImage(
      image: ImageStrings.tzlandPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
