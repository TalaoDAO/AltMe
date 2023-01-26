import 'package:flutter/material.dart';

class BackgroundCard extends StatelessWidget {
  const BackgroundCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(15),
    this.margin = EdgeInsets.zero,
    this.color,
    this.height,
    this.width,
  });

  final Widget? child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? color;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: child,
    );
  }
}
