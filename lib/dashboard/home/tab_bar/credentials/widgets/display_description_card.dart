import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DisplayDescriptionCard extends StatelessWidget {
  const DisplayDescriptionCard({
    super.key,
    required this.credentialModel,
    required this.style,
    this.maxLines = 5,
  });

  final CredentialModel credentialModel;
  final TextStyle style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final nameValue = getDescription(context);
    return MyText(
      nameValue,
      maxLines: maxLines,
      style: style,
    );
  }

  String getDescription(BuildContext context) {
    var nameValue = GetTranslation.getTranslation(
      credentialModel.credentialPreview.description,
      context.l10n,
    );
    if (nameValue == '') {
      nameValue = credentialModel.display.descriptionFallback;
    }

    return nameValue;
  }
}
