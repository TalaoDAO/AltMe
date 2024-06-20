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
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const [0.3, 1.0],
                )
              : null,
          color: isSelected
              ? null
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isSelected)
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.color,
                ),
                child: Image.asset(icon, height: Sizes.icon),
              )
            else
              Image.asset(icon, height: Sizes.icon),
            const SizedBox(
              width: Sizes.spaceXSmall,
            ),
            Text(
              text,
              maxLines: 1,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: isSelected ? null : Colors.grey[400],
                  ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
