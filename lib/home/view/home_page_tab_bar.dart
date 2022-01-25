import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/constants.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar_element.dart';
import 'package:ssi_crypto_wallet/l10n/l10n.dart';

class HomePageTabBar extends StatelessWidget {
  const HomePageTabBar({
    Key? key,
    required TabController tabController,
    required this.isTabBarShrinked,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;
  final bool isTabBarShrinked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      constraints: const BoxConstraints(
        maxHeight: tabBarExpandedSize + 53,
      ),
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              padding: const EdgeInsets.only(
                left: 8,
                top: 8,
                right: 8,
              ),
              indicatorPadding: const EdgeInsets.all(8),
              controller: _tabController,
              tabs: <Widget>[
                TabBarElement(
                  isTabBarShrinked: isTabBarShrinked,
                  icon: Icons.animation,
                  menuLabel: l10n.tokenMenu,
                ),
                TabBarElement(
                  isTabBarShrinked: isTabBarShrinked,
                  icon: Icons.blur_on,
                  menuLabel: l10n.nftMenu,
                ),
                TabBarElement(
                  isTabBarShrinked: isTabBarShrinked,
                  icon: Icons.portrait,
                  menuLabel: l10n.ssiMenu,
                ),
              ],
            ),
            if (isTabBarShrinked)
              const SizedBox.shrink()
            else
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  l10n.tokenMenuExplanation,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).tabBarTheme.labelColor,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
