import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DogamiPassWidget extends StatelessWidget {
  const DogamiPassWidget({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final dogamiPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as DogamiPassModel;

    return const CredentialImage(
      image: ImageStrings.dogamiPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
