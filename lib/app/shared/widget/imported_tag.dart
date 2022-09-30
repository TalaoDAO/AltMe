import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class ImportedTag extends StatelessWidget {
  const ImportedTag({Key? key}) : super(key: key);

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
