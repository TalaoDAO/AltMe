import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: Sizes.spaceXSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Text(
          l10n.edit,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
