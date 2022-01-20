import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/constants.dart';

class TabBarElement extends StatelessWidget {
  const TabBarElement({
    Key? key,
    required this.isTabBarShrinked,
    required this.icon,
    required this.menuLabel,
  }) : super(key: key);

  final bool isTabBarShrinked;
  final IconData icon;
  final String menuLabel;

  @override
  Widget build(BuildContext context) {
    if (isTabBarShrinked) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
        ),
      );
    }
    return SizedBox(
      height:
          isTabBarShrinked ? tabBarShrinkedSize - 30 : tabBarExpandedSize - 30,
      width: tabBarShrinkedSize + 60,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
            ),
            const Spacer(),
            Text(menuLabel),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
