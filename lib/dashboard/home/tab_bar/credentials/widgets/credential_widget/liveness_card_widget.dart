import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class LivenessCardWidget extends StatelessWidget {
  const LivenessCardWidget({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final LivenessCardModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as LivenessCardModel;
    // final l10n = context.l10n;

    return const CredentialImage(
      image: ImageStrings.livenessCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
