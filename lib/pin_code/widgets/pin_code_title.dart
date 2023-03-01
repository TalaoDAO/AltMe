import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class PinCodeTitle extends StatelessWidget {
  const PinCodeTitle({
    super.key,
    required this.title,
    required this.subTitle,
    required this.allowAction,
  });

  final String title;
  final String? subTitle;
  final bool allowAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: allowAction
              ? Theme.of(context).textTheme.pinCodeTitle
              : Theme.of(context)
                  .textTheme
                  .pinCodeTitle
                  .copyWith(color: Theme.of(context).colorScheme.redColor),
        ),
        if (subTitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subTitle!,
            style: allowAction
                ? Theme.of(context).textTheme.pinCodeMessage
                : Theme.of(context)
                    .textTheme
                    .pinCodeMessage
                    .copyWith(color: Theme.of(context).colorScheme.redColor),
            textAlign: TextAlign.center,
          ),
        ]
      ],
    );
  }
}
