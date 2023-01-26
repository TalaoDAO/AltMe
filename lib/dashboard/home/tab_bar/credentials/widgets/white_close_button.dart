import 'package:flutter/material.dart';

class WhiteCloseButton extends StatelessWidget {
  const WhiteCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        padding: const EdgeInsets.all(1.5),
        child: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.background,
          size: 20,
        ),
      ),
    );
  }
}
