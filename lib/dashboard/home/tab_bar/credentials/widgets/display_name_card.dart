import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DisplayNameCard extends StatelessWidget {
  const DisplayNameCard({
    super.key,
    required this.credentialModel,
    required this.style,
  });
  final CredentialModel credentialModel;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final nameValue = getName(context);
    return MyText(
      nameValue,
      maxLines: 1,
      style: style,
    );
  }

  String getName(BuildContext context) {
    var nameValue = GetTranslation.getTranslation(
      credentialModel.credentialPreview.name,
      context.l10n,
    );
    if (nameValue == '') {
      nameValue = credentialModel.display.nameFallback;
    }
    if (nameValue == '') {
      nameValue = credentialModel.credentialPreview.type.last;
    }

    return nameValue;
  }
}
