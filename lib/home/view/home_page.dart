import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/constants.dart';
import 'package:ssi_crypto_wallet/home/view/floating_action_menu.dart';

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
              constraints: const BoxConstraints(maxHeight: 300),
              child: Material(
                color: Colors.transparent,
                child: TabBar(
                  padding: const EdgeInsets.all(8),
                  indicatorPadding: const EdgeInsets.all(8),
                  labelColor: Colors.pink,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.purple,
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      height: isTabBarShrinked
                          ? tabBarShrinkedSize
                          : tabBarExpandedSize,
                      child: TabBarElement(
                        isTabBarShrinked: isTabBarShrinked,
                        icon: const Icon(Icons.animation),
                      ),
                    ),
                    Tab(
                      height: isTabBarShrinked
                          ? tabBarShrinkedSize
                          : tabBarExpandedSize,
                      child: TabBarElement(
                        isTabBarShrinked: isTabBarShrinked,
                        icon: const Icon(Icons.blur_on),
                      ),
                    ),
                    Tab(
                      height: isTabBarShrinked
                          ? tabBarShrinkedSize
                          : tabBarExpandedSize,
                      child: TabBarElement(
                        isTabBarShrinked: isTabBarShrinked,
                        icon: const Icon(Icons.portrait),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isTabBarShrinked = !isTabBarShrinked;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text("Here is the tokens' list"),
                      ),
                    ),
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
        color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: icon,
        ),
      ),
    );
  }
}
