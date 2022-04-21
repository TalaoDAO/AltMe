import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialField extends StatelessWidget {
  const CredentialField({
    Key? key,
    required this.value,
    this.title,
  }) : super(key: key);

  final String value;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return HasDisplay(
      value: value,
      child: DisplayCredentialField(title: title, value: value),
    );
  }
}

class DisplayCredentialField extends StatelessWidget {
  const DisplayCredentialField({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String? title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          if (title != null)
            Text(
              '$title: ',
              style: Theme.of(context).textTheme.credentialFieldTitle,
            ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.credentialFieldDescription,
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
