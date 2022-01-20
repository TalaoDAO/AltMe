import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/constants.dart';

class TabBarElement extends StatelessWidget {
  const TabBarElement({
    Key? key,
    required this.isTabBarShrinked,
    required this.icon,
  }) : super(key: key);

  final bool isTabBarShrinked;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    if (isTabBarShrinked) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: icon,
      );
    }
    return SizedBox(
      height:
          isTabBarShrinked ? tabBarShrinkedSize - 30 : tabBarExpandedSize - 30,
      width: tabBarShrinkedSize + 60,
      child: Container(
        // color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: icon,
        ),
      ),
    );
  }
}
