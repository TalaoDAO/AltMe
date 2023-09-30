import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class BloometaPassWidget extends StatelessWidget {
  const BloometaPassWidget({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final bloometaPassModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as BloometaPassModel;
    // final l10n = context.l10n;

    return const CredentialImage(
      image: ImageStrings.bloometaPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
