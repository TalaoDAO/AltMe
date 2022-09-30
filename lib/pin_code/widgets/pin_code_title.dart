import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class PinCodeTitle extends StatelessWidget {
  const PinCodeTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.pinCodeTitle,
        ),
        const SizedBox(height: 10),
        Text(
          l10n.pinCodeMessage,
          style: Theme.of(context).textTheme.pinCodeMessage,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
