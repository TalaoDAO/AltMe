import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TextFieldDialog extends StatefulWidget {
  const TextFieldDialog({
    Key? key,
    required this.title,
    this.subtitle,
    this.initialValue,
    this.yes,
    this.no,
    this.dialogColor,
    this.bgColor,
    this.textColor,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? initialValue;
  final String? yes;
  final String? no;
  final Color? dialogColor;
  final Color? bgColor;
  final Color? textColor;

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

    final color = widget.dialogColor ?? Theme.of(context).colorScheme.primary;
    final background =
        widget.bgColor ?? Theme.of(context).colorScheme.background;
    final text = widget.textColor ?? Theme.of(context).colorScheme.dialogText;

    return AlertDialog(
      backgroundColor: background,
      contentPadding: const EdgeInsets.only(
        top: 24,
        bottom: 16,
        left: 24,
        right: 24,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style:
                Theme.of(context).textTheme.dialogTitle.copyWith(color: text),
            textAlign: TextAlign.center,
          ),
          if (widget.subtitle != null)
            Text(
              widget.subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .dialogSubtitle
                  .copyWith(color: text),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 24),
          BaseTextField(
            label: l10n.credentialAlias,
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            borderColor: Theme.of(context).colorScheme.dialogText,
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: MyOutlinedButton(
                  text: no,
                  verticalSpacing: 8,
                  fontSize: 13,
                  borderColor: color,
                  backgroundColor: background,
                  textColor: color,
                  onPressed: () {
                    Navigator.of(context).pop('');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MyElevatedButton(
                  text: yes,
                  verticalSpacing: 8,
                  backgroundColor: color,
                  textColor: background,
                  fontSize: 13,
                  onPressed: () {
                    Navigator.of(context).pop(controller.text);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
