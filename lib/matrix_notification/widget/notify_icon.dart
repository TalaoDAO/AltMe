import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class NotifyIcon extends StatelessWidget {
  const NotifyIcon({
    super.key,
    required this.onTap,
    this.badgeCount = 0,
  });

  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: badges.Badge(
          showBadge: badgeCount > 0,
          badgeContent: Text(
            badgeCount.toString(),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          child: Icon(
            Icons.notification_add_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
    );
  }
}
