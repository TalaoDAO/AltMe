import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class MaxButton extends StatelessWidget {
  const MaxButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: Sizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Text(
          l10n.max,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
