import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// How many single-use copies of a batch-issued credential are left, as
/// "×[count]". Each copy is destroyed once presented.
class BatchCountBadge extends StatelessWidget {
  const BatchCountBadge({super.key, required this.count, this.small = false});

  final int count;

  /// A smaller badge, for the corner of a card in a list.
  final bool small;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: context.l10n.batchCopiesCount(count),
      excludeSemantics: true,
      child: Tooltip(
        message: context.l10n.batchCopiesCount(count),
        child: Container(
          padding: small
              ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '×$count',
            style:
                (small
                        ? Theme.of(context).textTheme.labelSmall
                        : Theme.of(context).textTheme.labelLarge)
                    ?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
          ),
        ),
      ),
    );
  }
}
