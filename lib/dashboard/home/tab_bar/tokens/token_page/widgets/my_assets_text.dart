import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class MyAssetsText extends StatelessWidget {
  const MyAssetsText({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        l10n.myAssets,
        style: Theme.of(context).textTheme.infoTitle,
      ),
    );
  }
}
