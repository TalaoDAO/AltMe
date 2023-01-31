import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class PigsPassWidget extends StatelessWidget {
  const PigsPassWidget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final pigsPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as PigsPassModel;

    return const CredentialImage(
      image: ImageStrings.pigsPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
