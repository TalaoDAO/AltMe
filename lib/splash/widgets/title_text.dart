import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MyText(
      l10n.splashTitle,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.starterTitleStyle,
    );
  }
}
