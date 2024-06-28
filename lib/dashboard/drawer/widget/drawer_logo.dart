import 'package:altme/app/app.dart';

import 'package:flutter/material.dart';

class DrawerLogo extends StatelessWidget {
  const DrawerLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WalletLogo(
          height: 90,
          width: MediaQuery.of(context).size.shortestSide * 0.5,
          showPoweredBy: true,
        ),
        const SizedBox(height: Sizes.spaceSmall),
      ],
    );
  }
}
