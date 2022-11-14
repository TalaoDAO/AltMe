import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/widget/widget.dart';
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
      title: MyText(title),
      subtitle: Text(
        subTitle,
      ),
      trailing: Center(
        child: Image.asset(
          imageAssetPath,
          width: Sizes.icon4x,
          height: Sizes.icon4x,
        ),
      ),
    );
  }
}
