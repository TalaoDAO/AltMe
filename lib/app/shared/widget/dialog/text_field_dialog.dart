import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TextFieldDialog extends StatefulWidget {
  const TextFieldDialog({
    super.key,
    required this.title,
    required this.label,
    this.subtitle,
    this.initialValue,
    this.yes,
    this.no,
    this.dialogColor,
    this.bgColor,
    this.textColor,
  });

  final String title;
  final String label;
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
        widget.bgColor ?? Theme.of(context).colorScheme.popupBackground;
    final text = widget.textColor ?? Theme.of(context).colorScheme.label;

    return AlertDialog(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 0.3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .defaultDialogTitle
                .copyWith(color: text),
            textAlign: TextAlign.center,
          ),
          if (widget.subtitle != null)
            Text(
              widget.subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .defaultDialogSubtitle
                  .copyWith(color: text),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 24),
          BaseTextField(
            label: widget.label,
            controller: controller,
            borderRadius: Sizes.smallRadius,
            textCapitalization: TextCapitalization.sentences,
            fillColor: Theme.of(context).highlightColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: Sizes.spaceSmall,
              horizontal: Sizes.spaceSmall,
            ),
            borderColor: Theme.of(context).colorScheme.onInverseSurface,
          ),
          const SizedBox(height: 24),
          MyElevatedButton(
            text: yes,
            verticalSpacing: Sizes.normalRadius,
            elevation: 10,
            borderRadius: Sizes.smallRadius,
            backgroundColor: color,
            textColor: Theme.of(context).colorScheme.label,
            fontSize: 15,
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
          ),
          const SizedBox(width: Sizes.spaceNormal),
          MyOutlinedButton(
            text: no,
            verticalSpacing: Sizes.smallRadius,
            fontSize: 12,
            elevation: 0,
            borderColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            textColor: Theme.of(context).colorScheme.label,
            onPressed: () {
              Navigator.of(context).pop('');
            },
          ),
        ],
      ),
    );
  }
}
