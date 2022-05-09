import 'package:altme/app/app.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DisplayDescriptionCard extends StatelessWidget {
  const DisplayDescriptionCard(this.item, this.style, {Key? key})
      : super(key: key);
  final CredentialModel item;
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
      item.credentialPreview.description,
      context.l10n,
    );
    if (_nameValue == '') {
      _nameValue = item.display.descriptionFallback;
    }

    return _nameValue;
  }
}
