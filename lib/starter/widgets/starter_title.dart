import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class StarterTitle extends StatelessWidget {
  const StarterTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        context.l10n.starterTitle,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.starterTitleStyle,
      ),
    );
  }
}
