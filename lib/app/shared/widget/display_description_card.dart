import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DisplayDescriptionCard extends StatelessWidget {
  const DisplayDescriptionCard(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final nameValue = getDescription(context);
    return Text(
      nameValue,
      overflow: TextOverflow.fade,
      style: Theme.of(context).textTheme.credentialTextCard,
    );
  }

  String getDescription(BuildContext context) {
    var _nameValue = getTranslation(item.credentialPreview.description);
    if (_nameValue == '') {
      _nameValue = item.display.descriptionFallback;
    }

    return _nameValue;
  }
}
