import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class HomeTitleLeading extends StatelessWidget {
  const HomeTitleLeading({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: ImageIcon(
        const AssetImage(IconStrings.icMenu),
        color: Theme.of(context).colorScheme.leadingButton,
      ),
      onPressed: onPressed,
    );
  }
}
