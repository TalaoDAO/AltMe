import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DrawerCloseButton extends StatelessWidget {
  const DrawerCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              l10n.close,
              style: Theme.of(context).textTheme.close,
            ),
            const SizedBox(width: 5),
            Image.asset(
              IconStrings.closeCircle,
              height: 22,
            )
          ],
        ),
      ),
    );
  }
}
