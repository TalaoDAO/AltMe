import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 35;
    return Container(
      height: 25,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.background,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: LinearProgressIndicator(value: value),
        ),
      ),
    );
  }
}
