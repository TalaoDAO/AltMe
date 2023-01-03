import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class BunnyPassWidget extends StatelessWidget {
  const BunnyPassWidget({Key? key, required this.credentialModel})
      : super(key: key);
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
