import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.title,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final Widget? trailing;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TransparentInkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Sizes.spaceNormal),
        margin: const EdgeInsets.all(Sizes.spaceXSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.drawerSurface,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              Sizes.normalRadius,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
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
                color: Theme.of(context).colorScheme.unSelectedLabel,
              )
            ],
          ],
        ),
      ),
    );
  }
}
