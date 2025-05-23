import 'package:flutter/material.dart';

class DrawerItemDivider extends StatelessWidget {
  const DrawerItemDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
            width: 0.2,
          ),
        ),
      ),
    );
  }
}
