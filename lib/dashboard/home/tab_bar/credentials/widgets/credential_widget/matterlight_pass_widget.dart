import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class MatterlightPassWidget extends StatelessWidget {
  const MatterlightPassWidget({super.key, required this.credentialModel});
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
