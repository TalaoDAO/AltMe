import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class MatterlightPassDisplayInList extends StatelessWidget {
  const MatterlightPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return MatterlightPassView(credentialModel: credentialModel);
  }
}

class MatterlightPassDisplayInSelectionList extends StatelessWidget {
  const MatterlightPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return MatterlightPassView(credentialModel: credentialModel);
  }
}

class MatterlightPassDisplayDetail extends StatelessWidget {
  const MatterlightPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MatterlightPassView(credentialModel: credentialModel),
      ],
    );
  }
}

class MatterlightPassView extends Recto {
  const MatterlightPassView({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final matterlightPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as MatterlightPassModel;

    return const CredentialImage(
      image: ImageStrings.matterlightPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
