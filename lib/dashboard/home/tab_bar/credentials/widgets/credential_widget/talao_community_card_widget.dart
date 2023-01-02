import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TalaoCommunityCardWidget extends StatelessWidget {
  const TalaoCommunityCardWidget({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final talaoCommunityCardModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as TalaoCommunityCardModel;

    return CredentialImage(
      image: ImageStrings.talaoCommunityCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: Container(),
      ),
    );
  }
}
