import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ImportedTag extends StatelessWidget {
  const ImportedTag({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(Sizes.spaceXSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.borderColor,
          width: 0.35,
        ),
        borderRadius:
            const BorderRadius.all(Radius.circular(Sizes.smallRadius)),
      ),
      child: Text(
        l10n.imported.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
