import 'package:flutter/material.dart';

class PoweredByText extends StatelessWidget {
  const PoweredByText({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    // return SizedBox(
    //   child: Text(
    //     '${l10n.poweredBy} ${Parameters.appName}',
    //     maxLines: 1,
    //     textAlign: TextAlign.center,
    //     style: Theme.of(context).textTheme.bodyLarge,
    //   ),
    // );
    return const SizedBox.shrink();
  }
}
