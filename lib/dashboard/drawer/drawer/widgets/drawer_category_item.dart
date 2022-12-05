import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DrawerCategoryItem extends StatelessWidget {
  const DrawerCategoryItem({
    super.key,
    required this.title,
    required this.subTitle,
    this.onClick,
  });

  final String title;
  final String subTitle;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
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
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.drawerCategoryTitle,
                  ),
                  const SizedBox(
                    height: Sizes.space2XSmall,
                  ),
                  Text(
                    subTitle,
                    style: Theme.of(context).textTheme.drawerCategorySubTitle,
                  ),
                ],
              ),
            ),
            Container(
              width: Sizes.icon3x,
              alignment: Alignment.center,
              child: Icon(
                Icons.chevron_right,
                size: Sizes.icon2x,
                color: Theme.of(context).colorScheme.unSelectedLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
