import 'package:altme/app/app.dart';

import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  const MyTab({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  final String text;
  final String icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceXSmall,
          vertical: Sizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.normalRadius),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isSelected)
              Image.asset(
                icon,
                height: Sizes.icon,
                colorBlendMode: BlendMode.color,
                color: Theme.of(context).colorScheme.primaryContainer,
              )
            else
              Image.asset(icon, height: Sizes.icon),
            const SizedBox(width: Sizes.spaceXSmall),
            Text(
              text,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.inverseSurface,
              ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
