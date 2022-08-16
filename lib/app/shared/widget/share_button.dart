import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            IconStrings.share,
            width: Sizes.icon2x,
            height: Sizes.icon2x,
          ),
          const SizedBox(
            width: Sizes.spaceSmall,
          ),
          Text(
            l10n.share,
            style: Theme.of(context).textTheme.title,
          ),
        ],
      ),
    );
  }
}
