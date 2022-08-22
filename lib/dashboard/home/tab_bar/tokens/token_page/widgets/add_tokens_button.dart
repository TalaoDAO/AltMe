import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AddTokenButton extends StatelessWidget {
  const AddTokenButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              IconStrings.addSquare,
              width: Sizes.icon,
              height: Sizes.icon,
            ),
            const SizedBox(
              width: Sizes.spaceXSmall,
            ),
            Text(
              l10n.addTokens,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
