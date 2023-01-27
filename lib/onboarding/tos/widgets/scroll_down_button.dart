import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ScrollDownButton extends StatelessWidget {
  const ScrollDownButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FloatingActionButton(
      onPressed: onPressed,
      elevation: 10,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              l10n.scroll,
              style: Theme.of(context).textTheme.scrollText,
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
