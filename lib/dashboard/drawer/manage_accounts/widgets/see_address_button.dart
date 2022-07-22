import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SeeAddressButton extends StatelessWidget {
  const SeeAddressButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.all(Sizes.spaceXSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(
            Radius.circular(Sizes.smallRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.space2XSmall),
              child: Icon(
                Icons.remove_red_eye,
                size: Sizes.iconXSmall,
                color: Colors.white,
              ),
            ),
            Text(
              l10n.seeAddress.toUpperCase(),
              style: Theme.of(context).textTheme.miniButton,
            ),
          ],
        ),
      ),
    );
  }
}
