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
    return Tab(
      height: isTabBarShrinked ? tabBarShrinkedSize : tabBarExpandedSize,
      child: AnimatedContainer(
        height: isTabBarShrinked
            ? tabBarShrinkedSize - 30
            : tabBarExpandedSize - 30,
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceIn,
        child: SizedBox(
          width: tabBarShrinkedSize + 60,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: isTabBarShrinked
                ? Icon(
                    icon,
                  )
                : Column(
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
        ),
      ),
    );
  }
}
