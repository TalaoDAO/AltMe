import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class PinCodeTitle extends StatelessWidget {
  const PinCodeTitle({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.pinCodeTitle,
        ),
        if (subTitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subTitle!,
            style: Theme.of(context).textTheme.pinCodeMessage,
            textAlign: TextAlign.center,
          ),
        ]
      ],
    );
  }
}
