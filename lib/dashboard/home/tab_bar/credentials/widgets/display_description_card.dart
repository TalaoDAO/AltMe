import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DisplayDescriptionCard extends StatelessWidget {
  const DisplayDescriptionCard({
    Key? key,
    required this.credentialModel,
    required this.style,
    this.maxLines = 5,
  }) : super(key: key);

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
    var _nameValue = GetTranslation.getTranslation(
      credentialModel.credentialPreview.description,
      context.l10n,
    );
    if (_nameValue == '') {
      _nameValue = credentialModel.display.descriptionFallback;
    }

    return _nameValue;
  }
}
