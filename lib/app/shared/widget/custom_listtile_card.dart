import 'package:altme/app/app.dart';

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
      contentPadding: const EdgeInsets.all(Sizes.spaceSmall),
      tileColor: Theme.of(context).colorScheme.surfaceContainer,
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      subtitle: Text(
        subTitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      minVerticalPadding: 0,
      trailing: Image.asset(
        imageAssetPath,
        width: Sizes.icon5x,
        height: Sizes.icon5x,
      ),
    );
  }
}
