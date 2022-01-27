import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/home/view/floating_action_menu.dart';
import 'package:ssi_crypto_wallet/home/view/home_page_tab_bar.dart';

/// StatefulWidget or StatelessWidget
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),

      /// defining the route name
      settings: const RouteSettings(name: '/home'),

      /// defining transition animation if not the basic one
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
                  TabBarViewElement(TokenList(), 'Tokens'),
                  TabBarViewElement(TokenList(), 'NFTs'),
                  TabBarViewElement(TokenList(), 'SSI'),
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
    this.child,
    this.name, {
    Key? key,
  }) : super(key: key);
  final Widget child;
  final String name;
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      // Setting floatHeaderSlivers to true is required in order to float
      // the outer slivers over the inner scrollable.
      floatHeaderSlivers: false,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            // This widget takes the overlapping behavior of the SliverAppBar,
            // and redirects it to the SliverOverlapInjector below. If it is
            // missing, then it is possible for the nested "inner" scroll view
            // below to end up under the SliverAppBar even when the inner
            // scroll view thinks it has not been scrolled.
            // This is not necessary if the "headerSliverBuilder" only builds
            // widgets that do not overlap the next sliver
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              delegate: _HeaderDelegate(),
              floating: true,
              pinned: true,
            ),
          ),
        ];
      },
      body: SafeArea(
        top: false,
        bottom: false,
        child: Builder(
          // This Builder is needed to provide a BuildContext that is
          // "inside" the NestedScrollView, so that
          // sliverOverlapAbsorberHandleFor() can find the
          // NestedScrollView.
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
              ),
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: CustomScrollView(
                  // The "controller" and "primary" members should be left
                  // unset, so that the NestedScrollView can control this
                  // inner scroll view.
                  // If the "controller" property is set, then this scroll
                  // view will not be associated with the NestedScrollView.
                  // The PageStorageKey should be unique to this ScrollView;
                  // it allows the list to remember its scroll position when
                  // the tab view is not on the screen.
                  key: PageStorageKey<String>(name),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      // In this example, the inner scroll view has
                      // fixed-height list items, hence the use of
                      // SliverFixedExtentList. However, one could use any
                      // sliver widget here, e.g. SliverList or SliverGrid.
                      sliver: SliverFixedExtentList(
                        // The items in this example are fixed to 48 pixels
                        // high. This matches the Material Design spec for
                        // ListTile widgets.
                        itemExtent: 48,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            // This builder is called for each child.
                            // In this example, we just number each list item.
                            return ListTile(
                              title: Center(child: Text('Item $index')),
                            );
                          },
                          // The childCount of the SliverChildBuilderDelegate
                          // specifies how many children this inner list
                          // has. In this example, each tab has a list of
                          // exactly 30 items, but this is arbitrary.
                          childCount: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.primaries[1],
        ),
        child: const AppMainContentHeader());
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
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
      padding: const EdgeInsets.only(left: 20, right: 20),
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
    );
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
