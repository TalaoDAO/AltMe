import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TezoniaPassWidget extends StatelessWidget {
  const TezoniaPassWidget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final tezoniaPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as TezoniaPassModel;

    return const CredentialImage(
      image: ImageStrings.tezoniaPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
