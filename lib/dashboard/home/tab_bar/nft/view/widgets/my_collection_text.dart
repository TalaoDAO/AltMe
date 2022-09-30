import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class MyCollectionText extends StatelessWidget {
  const MyCollectionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(
      l10n.myCollection,
      style: Theme.of(context).textTheme.infoTitle,
    );
  }
}
