import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialField extends StatelessWidget {
  const CredentialField({
    Key? key,
    required this.value,
    this.title,
    this.textColor,
  }) : super(key: key);

  final String value;
  final String? title;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return HasDisplay(
      value: value,
      child: DisplayCredentialField(
        title: title,
        value: value,
        textColor: textColor,
      ),
    );
  }
}

class DisplayCredentialField extends StatelessWidget {
  const DisplayCredentialField({
    Key? key,
    required this.title,
    required this.value,
    this.textColor,
  }) : super(key: key);

  final String? title;
  final String value;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          if (title != null)
            Text(
              '$title: ',
              style: textColor == null
                  ? Theme.of(context).textTheme.credentialFieldTitle
                  : Theme.of(context)
                      .textTheme
                      .credentialFieldTitle
                      .copyWith(color: textColor),
            ),
          Flexible(
            child: Text(
              value,
              style: textColor == null
                  ? Theme.of(context).textTheme.credentialFieldDescription
                  : Theme.of(context)
                      .textTheme
                      .credentialFieldDescription
                      .copyWith(color: textColor),
              maxLines: 5,
              overflow: TextOverflow.fade,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class HasDisplay extends StatelessWidget {
  const HasDisplay({Key? key, required this.value, required this.child})
      : super(key: key);

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
