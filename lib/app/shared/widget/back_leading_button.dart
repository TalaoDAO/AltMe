import 'package:flutter/material.dart';

class BackLeadingButton extends StatelessWidget {
  const BackLeadingButton({Key? key, this.onPressed}) : super(key: key);

  final GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.chevron_left,
        color: Theme.of(context).colorScheme.primary,
        size: 35,
      ),
    );
  }
}
