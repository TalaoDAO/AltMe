import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class AddAccountButton extends StatelessWidget {
  const AddAccountButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  IconStrings.addSquare,
                  width: Sizes.icon2x,
                ),
                const SizedBox(
                  width: Sizes.spaceSmall,
                ),
                Text(
                  l10n.cryptoAddAccount,
                  style: Theme.of(context).textTheme.title,
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              l10n.createOrImportNewAccount,
              style: Theme.of(context).textTheme.listSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}
