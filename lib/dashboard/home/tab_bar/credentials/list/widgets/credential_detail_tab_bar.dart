import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
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
          style: Theme.of(context).textTheme.badgeStyle,
          textAlign: TextAlign.center,
        ),
        position: badges.BadgePosition.topEnd(end: 5,top: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          decoration: isSelected
              ? BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
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
                  ? textTheme.credentialManifestDescription
                      .copyWith(fontWeight: FontWeight.bold)
                  : textTheme.credentialManifestDescription
                      .copyWith(color: colorScheme.onTertiary),
            ),
          ),
        ),
      ),
    );
  }
}
