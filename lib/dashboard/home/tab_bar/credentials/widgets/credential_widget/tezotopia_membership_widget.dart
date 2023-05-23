import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class TezotopiaMemberShipWidget extends StatelessWidget {
  const TezotopiaMemberShipWidget({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final tezotopiaMembershipModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as TezotopiaMembershipModel;

    return const CredentialImage(
      image: ImageStrings.tezotopiaMemberShip,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: Center(),
      ),
    );
  }
}
