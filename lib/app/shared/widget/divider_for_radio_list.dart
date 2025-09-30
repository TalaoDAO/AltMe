import 'package:flutter/material.dart';

class DividerForRadioList extends StatelessWidget {
  const DividerForRadioList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Divider(
        height: 0,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
      ),
    );
  }
}
