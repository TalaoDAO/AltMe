import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class MyAssetsText extends StatelessWidget {
  const MyAssetsText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(
      l10n.myAssets,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
