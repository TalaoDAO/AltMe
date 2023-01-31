import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class BunnyPassWidget extends StatelessWidget {
  const BunnyPassWidget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final bunnyPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as BunnyPassModel;

    return const CredentialImage(
      image: ImageStrings.bunnyPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
