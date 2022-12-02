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
    return ListTile(
      onTap: onClick,
      tileColor: Theme.of(context).colorScheme.drawerSurface,
      selectedTileColor: Theme.of(context).colorScheme.primary,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: Sizes.spaceSmall,
      ),
      minVerticalPadding: Sizes.spaceSmall,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            Sizes.normalRadius,
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.drawerCategoryTitle,
      ),
      subtitle: Text(
        subTitle,
        style: Theme.of(context).textTheme.drawerCategorySubTitle,
      ),
      trailing: Container(
        width: Sizes.icon3x,
        alignment: Alignment.center,
        child: Icon(
          Icons.chevron_right,
          size: Sizes.icon2x,
          color: Theme.of(context).colorScheme.unSelectedLabel,
        ),
      ),
    );
  }
}
