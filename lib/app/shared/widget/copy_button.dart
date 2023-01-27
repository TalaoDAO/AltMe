import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            IconStrings.copy,
            width: Sizes.icon2x,
            height: Sizes.icon2x,
          ),
          const SizedBox(
            width: Sizes.spaceSmall,
          ),
          Text(
            l10n.copy,
            style: Theme.of(context).textTheme.title,
          ),
        ],
      ),
    );
  }
}
