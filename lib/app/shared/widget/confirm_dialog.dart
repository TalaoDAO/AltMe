import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.title,
    this.subtitle,
    this.yes = 'Yes',
    this.no = 'No',
    this.lock = false,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String yes;
  final String no;
  final bool lock;

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
        children: [
          if (lock)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.lock_open,
                color: Theme.of(context).colorScheme.error,
              ),
            )
          else
            const SizedBox.shrink(),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: BaseButton.transparent(
                  borderColor: Theme.of(context).colorScheme.secondaryContainer,
                  textColor: Theme.of(context).colorScheme.secondaryContainer,
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(yes),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BaseButton.primary(
                  borderColor: Theme.of(context).colorScheme.secondaryContainer,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(no),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
