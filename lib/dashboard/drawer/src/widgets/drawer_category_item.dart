import 'package:altme/app/shared/constants/sizes.dart';

import 'package:flutter/material.dart';

class DrawerCategoryItem extends StatelessWidget {
  const DrawerCategoryItem({
    super.key,
    required this.title,
    this.subTitle,
    this.onClick,
    this.trailing,
  });

  final String title;
  final String? subTitle;
  final VoidCallback? onClick;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
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
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (subTitle != null) ...[
                    const SizedBox(height: Sizes.space2XSmall),
                    Text(
                      subTitle!,
                      style: Theme.of(context).textTheme.bodyMedium,
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
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
