import 'package:altme/app/app.dart';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class CredentialDetailTabbar extends StatelessWidget {
  const CredentialDetailTabbar({
    super.key,
    required this.isSelected,
    required this.title,
    required this.onTap,
    this.badgeCount = 0,
  });

  final bool isSelected;
  final String title;
  final GestureTapCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return TransparentInkWell(
      onTap: onTap,
      child: badges.Badge(
        showBadge: badgeCount > 0,
        badgeContent: Text(
          badgeCount.toString(),
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        position: badges.BadgePosition.topEnd(end: 5, top: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          decoration: isSelected
              ? BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.07),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Sizes.smallRadius),
                    topRight: Radius.circular(Sizes.smallRadius),
                  ),
                )
              : null,
          child: Center(
            child: Text(
              title,
              style: isSelected
                  ? textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)
                  : textTheme.bodyMedium!
                      .copyWith(color: colorScheme.secondaryContainer),
            ),
          ),
        ),
      ),
    );
  }
}
