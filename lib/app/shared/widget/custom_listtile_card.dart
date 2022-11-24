import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomListTileCard extends StatelessWidget {
  const CustomListTileCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imageAssetPath,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final String imageAssetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.normalRadius),
        ),
      ),
      contentPadding: const EdgeInsets.all(Sizes.spaceNormal),
      tileColor: Theme.of(context).colorScheme.surface,
      title: MyText(
        title,
        style: Theme.of(context).textTheme.customListTileTitleStyle,
      ),
      subtitle: Text(
        subTitle,
        style: Theme.of(context).textTheme.customListTileSubTitleStyle,
      ),
      minVerticalPadding: 0,
      trailing: Image.asset(
        imageAssetPath,
        width: Sizes.icon5x,
        height: Sizes.icon5x,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
