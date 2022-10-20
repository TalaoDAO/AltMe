import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SenderReceiver extends StatelessWidget {
  const SenderReceiver({
    Key? key,
    required this.from,
    required this.to,
    required this.dAppName,
  }) : super(key: key);

  final String from;
  final String to;
  final String dAppName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        SenderReceiverCard(title: l10n.from, value: from),
        const SizedBox(height: Sizes.spaceSmall),
        SenderReceiverCard(title: '${l10n.to}\n$dAppName', value: to),
      ],
    );
  }
}

class SenderReceiverCard extends StatelessWidget {
  const SenderReceiverCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      color: Theme.of(context).colorScheme.cardBackground,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.caption,
            ),
            MyText(
              value,
              style: Theme.of(context).textTheme.walletAddress,
            ),
          ],
        ),
      ),
    );
  }
}
