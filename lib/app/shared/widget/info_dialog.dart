import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    Key? key,
    required this.title,
    this.subtitle,
    this.button = 'Ok',
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String button;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      contentPadding: const EdgeInsets.only(
        top: 24,
        bottom: 16,
        left: 24,
        right: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          const SizedBox(height: 24),
          BaseButton.primary(
            context: context,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(button),
          ),
        ],
      ),
    );
  }
}
