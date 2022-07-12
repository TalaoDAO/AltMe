import 'package:altme/app/app.dart';
import 'package:altme/import_wallet/import_wallet.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class WalletTypeItem extends StatelessWidget {
  const WalletTypeItem({Key? key, required this.model, this.onTap})
      : super(key: key);

  final WalletTypeModel model;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Sizes.spaceXSmall),
        margin: const EdgeInsets.all(Sizes.space2XSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(Sizes.smallRadius)),
          border: Border.all(color: Theme.of(context).colorScheme.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(Sizes.spaceXSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(Sizes.smallRadius),
                ),
              ),
              child: Image.asset(
                model.imagePath,
                width: Sizes.icon2x,
                height: Sizes.icon2x,
              ),
            ),
            const SizedBox(
              width: Sizes.spaceXSmall,
            ),
            Text(
              model.title,
              style: Theme.of(context).textTheme.caption,
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: Sizes.icon,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(
              width: Sizes.spaceSmall,
            ),
          ],
        ),
      ),
    );
  }
}
