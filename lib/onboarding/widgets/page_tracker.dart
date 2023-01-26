import 'package:flutter/material.dart';

class PageTracker extends StatelessWidget {
  const PageTracker({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    const double selectedWidth = 22;
    const double unselectedWidth = 10;
    const double height = 10;
    const double radius = 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: index == 1 ? selectedWidth : unselectedWidth,
          height: height,
          decoration: BoxDecoration(
            color: index == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        const SizedBox(width: 7),
        Container(
          width: index == 2 ? selectedWidth : unselectedWidth,
          height: height,
          decoration: BoxDecoration(
            color: index == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        const SizedBox(width: 7),
        Container(
          width: index == 3 ? selectedWidth : unselectedWidth,
          height: height,
          decoration: BoxDecoration(
            color: index == 3
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(radius),
          ),
        )
      ],
    );
  }
}
