import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TextFieldDialog extends StatefulWidget {
  const TextFieldDialog({
    Key? key,
    required this.title,
    this.subtitle,
    this.initialValue,
    this.yes,
    this.no,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? initialValue;
  final String? yes;
  final String? no;

  @override
  _TextFieldDialogState createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();

    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final yes = widget.yes ?? l10n.yes;
    final no = widget.no ?? l10n.no;

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      contentPadding: const EdgeInsets.only(
        top: 24,
        bottom: 16,
        left: 24,
        right: 24,
      ),
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseTextField(
            label: l10n.credentialAlias,
            controller: controller,
            // icon: Icons.wallet,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: BaseButton.transparent(
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop(controller.text);
                  },
                  child: Text(yes),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BaseButton.primary(
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop('');
                  },
                  child: Text(no),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
