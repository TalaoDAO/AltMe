import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/widget/display_selective_disclosure.dart';
import 'package:flutter/material.dart';

class DisclosureDetail extends StatelessWidget {
  const DisclosureDetail({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DisplaySelectiveDisclosure(
      credentialModel: credentialModel,
      claims: null,
      showVertically: true,
    );
  }
}
