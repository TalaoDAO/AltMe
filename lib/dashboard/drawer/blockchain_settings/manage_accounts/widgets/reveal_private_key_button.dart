import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class RevealPrivateKeyButton extends StatelessWidget {
  const RevealPrivateKeyButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.all(Sizes.spaceXSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(Sizes.smallRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              IconStrings.lockCircle,
              width: Sizes.icon,
              color: Colors.white,
            ),
            Text(
              l10n.revealPrivateKey.toUpperCase(),
              style: Theme.of(context).textTheme.miniButton,
            ),
          ],
        ),
      ),
    );
  }
}
