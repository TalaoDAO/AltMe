import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class DialogCloseButton extends StatelessWidget {
  const DialogCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            l10n.close,
            style: Theme.of(context).textTheme.dialogClose,
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.all(0.5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.closeIconColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: Sizes.icon,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
