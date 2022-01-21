import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/constants.dart';
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
      drawer: const Drawer(
        child: Center(
          child: Text(
            'this is the drawer which contains the menu',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text('Account 1'),
        actions: [
          InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.qr_code_scanner),
            ),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: isTabBarShrinked
                    ? tabBarShrinkedSize + 18
                    : tabBarExpandedSize + 53,
              ),
              child: Material(
                child: HomePageTabBar(
                  tabController: _tabController,
                  isTabBarShrinked: isTabBarShrinked,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
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
                        )),
                    child: IconButton(
                      icon: Icon(Icons.ac_unit_rounded),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 11, left: 11),
                        child: Container(
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.surface,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isTabBarShrinked = !isTabBarShrinked;
                              });
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Text("Here is the tokens' list"),
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Center(
                    child: Text('Here is the grid showing NFTs'),
                  ),
                  const Center(
                    child: Text('Here is the grid showing credentials'),
                  ),
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
