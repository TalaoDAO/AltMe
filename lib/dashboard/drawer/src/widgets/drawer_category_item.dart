import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DrawerCategoryItem extends StatelessWidget {
  const DrawerCategoryItem({
    super.key,
    required this.title,
    this.subTitle,
    this.onClick,
    this.trailing,
    this.padding = const EdgeInsets.all(Sizes.spaceSmall),
  });

  final String title;
  final String? subTitle;
  final VoidCallback? onClick;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(Sizes.normalRadius),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.drawerCategoryTitle,
                  ),
                  if (subTitle != null) ...[
                    const SizedBox(height: Sizes.space2XSmall),
                    Text(
                      subTitle!,
                      style: Theme.of(context).textTheme.drawerCategorySubTitle,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else ...[
              const SizedBox(width: 16),
              Icon(
                Icons.chevron_right,
                size: Sizes.icon2x,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
