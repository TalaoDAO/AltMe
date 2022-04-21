import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({
    Key? key,
    this.color,
    this.strokeWidth = 3,
  }) : super(key: key);

  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.primary,
        ),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
