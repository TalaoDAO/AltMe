import 'package:flutter/material.dart';

class TransparentInkWell extends StatelessWidget {
  const TransparentInkWell({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: child,
    );
  }
}
