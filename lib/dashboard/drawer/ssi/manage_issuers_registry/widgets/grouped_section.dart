import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class GroupedSection extends StatelessWidget {
  const GroupedSection({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      margin: const EdgeInsets.all(Sizes.spaceXSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cardHighlighted,
        borderRadius: const BorderRadius.all(
          Radius.circular(Sizes.largeRadius),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
