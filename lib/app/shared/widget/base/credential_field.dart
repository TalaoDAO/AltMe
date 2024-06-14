import 'package:flutter/material.dart';

class CredentialField extends StatelessWidget {
  const CredentialField({
    super.key,
    required this.value,
    required this.showVertically,
    this.title,
    this.titleColor,
    this.valueColor,
    this.padding = const EdgeInsets.all(8),
  });

  final String value;
  final String? title;
  final Color? titleColor;
  final Color? valueColor;
  final EdgeInsetsGeometry padding;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    return HasDisplay(
      value: value,
      child: DisplayCredentialField(
        title: title,
        value: value,
        titleColor: titleColor,
        valueColor: valueColor,
        padding: padding,
        showVertically: showVertically,
      ),
    );
  }
}

class DisplayCredentialField extends StatelessWidget {
  const DisplayCredentialField({
    super.key,
    required this.title,
    required this.value,
    this.titleColor,
    this.valueColor,
    required this.padding,
    required this.showVertically,
  });

  final String? title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;
  final EdgeInsetsGeometry padding;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: SelectableText.rich(
        textAlign: TextAlign.left,
        TextSpan(
          children: <InlineSpan>[
            if (title != null) ...[
              TextSpan(
                text: showVertically ? title : '$title: ',
                style: textTheme.bodyMedium!.copyWith(
                  color: titleColor,
                ),
              ),
              if (showVertically) const TextSpan(text: ' \n'),
            ],
            TextSpan(
              text: value,
              style: textTheme.bodyMedium!.copyWith(color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}

class HasDisplay extends StatelessWidget {
  const HasDisplay({super.key, required this.value, required this.child});

  final String value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return child;
    } else {
      return const SizedBox.shrink();
    }
  }
}
