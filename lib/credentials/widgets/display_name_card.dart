import 'package:altme/app/app.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DisplayNameCard extends StatelessWidget {
  const DisplayNameCard(this.item, this.style, {Key? key}) : super(key: key);
  final CredentialModel item;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final nameValue = getName(context);
    return Text(
      nameValue,
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: style,
    );
  }

  String getName(BuildContext context) {
    var _nameValue = GetTranslation.getTranslation(
      item.credentialPreview.name,
      context.l10n,
    );
    if (_nameValue == '') {
      _nameValue = item.display.nameFallback;
    }
    if (_nameValue == '') {
      _nameValue = item.credentialPreview.type.last;
    }

    return _nameValue;
  }
}
