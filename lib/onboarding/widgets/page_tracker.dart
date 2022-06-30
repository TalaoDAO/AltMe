import 'package:flutter/material.dart';

class PageTracker extends StatelessWidget {
  const PageTracker({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    const double _selectedWidth = 22;
    const double _unselectedWidth = 10;
    const double _height = 10;
    const double _radius = 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: index == 1 ? _selectedWidth : _unselectedWidth,
          height: _height,
          decoration: BoxDecoration(
            color: index == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(_radius),
          ),
        ),
        const SizedBox(width: 7),
        Container(
          width: index == 2 ? _selectedWidth : _unselectedWidth,
          height: _height,
          decoration: BoxDecoration(
            color: index == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(_radius),
          ),
        ),
        const SizedBox(width: 7),
        Container(
          width: index == 3 ? _selectedWidth : _unselectedWidth,
          height: _height,
          decoration: BoxDecoration(
            color: index == 3
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(_radius),
          ),
        )
      ],
    );
  }
}
