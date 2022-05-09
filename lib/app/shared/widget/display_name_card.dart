import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DisplayNameCard extends StatelessWidget {
  const DisplayNameCard(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final nameValue = getName(context);
    return Text(
      nameValue,
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: Theme.of(context).textTheme.credentialTitleCard,
    );
  }

  String getName(BuildContext context) {
    var _nameValue = getTranslation(item.credentialPreview.name);
    if (_nameValue == '') {
      _nameValue = item.display.nameFallback;
    }
    if (_nameValue == '') {
      _nameValue = item.credentialPreview.type.last;
    }

    return _nameValue;
  }
}
