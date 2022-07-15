import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final String icon;
  final Widget? trailing;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.transparent,
      child: TransparentInkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MyText(
                title,
                style: Theme.of(context).textTheme.drawerItem,
              ),
            ),
            if (trailing != null)
              trailing!
            else ...[
              const SizedBox(width: 16),
              Icon(
                Icons.chevron_right,
                size: 26,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            ],
          ],
        ),
      ),
    );
  }
}
