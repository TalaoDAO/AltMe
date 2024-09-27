import 'package:altme/app/shared/launch_url/launch_url.dart';
import 'package:flutter/gestures.dart';
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
    this.type = 'string',
  });

  final String value;
  final String? title;
  final Color? titleColor;
  final Color? valueColor;
  final EdgeInsetsGeometry padding;
  final bool showVertically;
  final String type;

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
        type: type,
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
    this.type = 'string',
  });

  final String? title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;
  final EdgeInsetsGeometry padding;
  final bool showVertically;
  final String type;

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
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showVertically) const TextSpan(text: ' \n'),
            ],
            TextSpan(
              text: value,
              style: textTheme.bodyMedium!.copyWith(
                color: (type == 'uri' || type == 'email')
                    ? Theme.of(context).colorScheme.primary
                    : valueColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (type == 'uri') {
                    await LaunchUrl.launch(value);
                  }
                  if (type == 'email') {
                    await LaunchUrl.launch('mailto:$value');
                  }
                },
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
