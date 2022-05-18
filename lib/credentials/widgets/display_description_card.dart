import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DisplayDescriptionCard extends StatelessWidget {
  const DisplayDescriptionCard({
    Key? key,
    required this.credentialModel,
    required this.style,
  }) : super(key: key);
  final CredentialModel credentialModel;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final nameValue = getDescription(context);
    return Text(
      nameValue,
      overflow: TextOverflow.fade,
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
