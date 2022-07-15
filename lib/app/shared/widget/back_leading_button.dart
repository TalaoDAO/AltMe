import 'package:flutter/material.dart';

class BackLeadingButton extends StatelessWidget {
  const BackLeadingButton({
    Key? key,
    this.color,
    this.onPressed,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  final GestureTapCallback? onPressed;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorValue = color ?? Theme.of(context).colorScheme.onPrimary;
    return IconButton(
      padding: padding,
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.chevron_left,
        color: colorValue,
        size: 35,
      ),
    );
  }
}
