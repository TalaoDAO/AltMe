import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/constants.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar_element.dart';

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
    return TabBar(
      padding: const EdgeInsets.all(8),
      indicatorPadding: const EdgeInsets.all(8),
      // labelColor: Colors.pink,
      // unselectedLabelColor: Colors.grey,
      // indicatorColor: Colors.purple,
      controller: _tabController,
      tabs: <Widget>[
        Tab(
          height: isTabBarShrinked ? tabBarShrinkedSize : tabBarExpandedSize,
          child: TabBarElement(
            isTabBarShrinked: isTabBarShrinked,
            icon: const Icon(Icons.animation),
          ),
        ),
        Tab(
          height: isTabBarShrinked ? tabBarShrinkedSize : tabBarExpandedSize,
          child: TabBarElement(
            isTabBarShrinked: isTabBarShrinked,
            icon: const Icon(Icons.blur_on),
          ),
        ),
        Tab(
          height: isTabBarShrinked ? tabBarShrinkedSize : tabBarExpandedSize,
          child: TabBarElement(
            isTabBarShrinked: isTabBarShrinked,
            icon: const Icon(Icons.portrait),
          ),
        ),
      ],
    );
  }
}
