import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DescriptionDialog extends StatelessWidget {
  const DescriptionDialog({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final background = Theme.of(context).colorScheme.surface;

    return AlertDialog(
      backgroundColor: background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ImageIcon(
          //   AssetImage(icon),
          //   size: 50,
          //   color: color,
          // ),
          // const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.l10n.credentialManifestDescription}:',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.left,
              ),
              TransparentInkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.background,
                  ),
                  child: Icon(
                    Icons.clear_rounded,
                    size: 18,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
