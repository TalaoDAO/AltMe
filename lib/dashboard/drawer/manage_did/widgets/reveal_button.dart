import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class RevealButton extends StatelessWidget {
  const RevealButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.space2XSmall,
          horizontal: Sizes.spaceXSmall,
        ),
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
              width: Sizes.icon2x,
              color: Colors.white,
            ),
            const SizedBox(
              height: Sizes.space2XSmall,
            ),
            Text(
              l10n.reveal.toUpperCase(),
              style: Theme.of(context).textTheme.miniButton,
            ),
          ],
        ),
      ),
    );
  }
}
