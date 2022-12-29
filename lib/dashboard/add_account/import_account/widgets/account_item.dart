import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    super.key,
    this.onTap,
    required this.title,
    required this.iconPath,
  });

  final VoidCallback? onTap;
  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.spaceSmall),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceNormal,
        vertical: Sizes.spaceSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cardHighlighted,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            Sizes.smallRadius,
          ),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
            Container(
              width: Sizes.icon3x,
              height: Sizes.icon3x,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: iconPath.endsWith('.svg')
                  ? SvgPicture.asset(
                      iconPath,
                      width: Sizes.icon2x,
                      height: Sizes.icon2x,
                    )
                  : Image.asset(
                      iconPath,
                      width: Sizes.icon2x,
                      fit: BoxFit.scaleDown,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
