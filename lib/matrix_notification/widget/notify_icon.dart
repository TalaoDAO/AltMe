import 'package:altme/app/app.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
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
    return TransparentInkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ImageIcon(
            const AssetImage(IconStrings.notification),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          if (badgeCount != 0) const NotifyDot(),
        ],
      ),
    );
  }
}
