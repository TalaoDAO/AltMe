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
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 5,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.borderColor,
                width: 0.2,
              ),
            ),
          ),
          child: Row(
            children: [
              Image.asset(icon, height: 30),
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
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
