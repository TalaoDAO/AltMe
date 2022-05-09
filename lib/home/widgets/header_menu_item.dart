import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class HeaderMenuItem extends StatelessWidget {
  const HeaderMenuItem({
    Key? key,
    required this.iconData,
    required this.title,
    this.isSelected = false,
    this.onTapped,
  }) : super(key: key);

  final IconData iconData;
  final String title;
  final bool isSelected;
  final VoidCallback? onTapped;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        width: SizeHelper.headerButton,
        height: SizeHelper.headerButton,
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(SizeHelper.spaceSmall),
        decoration: BoxDecoration(
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColorDark.withOpacity(0.4),
                    blurRadius: 24,
                    spreadRadius: 1,
                    offset: Offset.zero,
                  )
                ]
              : null,
          color: !isSelected ? Theme.of(context).cardColor : null,
          gradient: isSelected ? Theme.of(context).primaryButtonGradient : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(SizeHelper.radiusNormal),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.background,
              size: SizeHelper.iconNormal,
            ),
            const SizedBox(
              height: SizeHelper.spaceXSmall,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.background,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
