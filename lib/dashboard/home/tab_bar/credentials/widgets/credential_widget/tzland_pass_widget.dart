import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TzlandPassWidget extends StatelessWidget {
  const TzlandPassWidget({super.key, required this.credentialModel});
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
