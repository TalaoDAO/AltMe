import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TrooperzPassWidget extends StatelessWidget {
  const TrooperzPassWidget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final trooperzPassModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as TrooperzPassModel;

    return const CredentialImage(
      image: ImageStrings.trooperzPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
