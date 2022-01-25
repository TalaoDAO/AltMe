import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/home/view/floating_action_menu.dart';
import 'package:ssi_crypto_wallet/home/view/home_page_tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      settings: const RouteSettings(name: '/home'),
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // ignore: prefer_int_literals
        const begin = 0.0;
        const end = 1.0;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return FadeTransition(opacity: offsetAnimation, child: child);
      },
    );
  }

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool isTabBarShrinked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: const AppDrawerMenuButton(),
        centerTitle: true,
        title: const AccountTitle(),
        actions: const [
          QrCodeScannerMenuButton(),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            HomePageTabBar(
              tabController: _tabController,
              isTabBarShrinked: isTabBarShrinked,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  TabBarViewElement(TokenList()),
                  TabBarViewElement(TokenList()),
                  TabBarViewElement(TokenList()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionMenu(),
    );
  }
}

class TabBarViewElement extends StatelessWidget {
  const TabBarViewElement(
    this.child, {
    Key? key,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [AppMainContentHeader(), TokenList()],
      ),
    );
  }
}

class TokenList extends StatelessWidget {
  const TokenList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(32),
          child: Text('Here is the list'),
        ),
        SizedBox(
          height: 300,
        ),
        SizedBox(
          height: 300,
        ),
        SizedBox(
          height: 300,
        )
      ],
    );
  }
}

class AppMainContentHeader extends StatelessWidget {
  const AppMainContentHeader({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryVariant,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 3,
              left: 3,
              right: 3,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.ac_unit_rounded),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class QrCodeScannerMenuButton extends StatelessWidget {
  const QrCodeScannerMenuButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}

class AccountTitle extends StatelessWidget {
  const AccountTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Account 1');
  }
}

class AppDrawerMenuButton extends StatelessWidget {
  const AppDrawerMenuButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Center(
        child: Text(
          'this is the drawer which contains the menu',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
