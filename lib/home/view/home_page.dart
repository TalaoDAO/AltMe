import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ssi_crypto_wallet/credential/credential_list.dart';
import 'package:ssi_crypto_wallet/home/home.dart';
import 'package:ssi_crypto_wallet/home/view/drawer/home_page_drawer.dart';
import 'package:ssi_crypto_wallet/home/view/floating_action_menu_button.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar/home_page_tab_bar.dart';
import 'package:ssi_crypto_wallet/home/view/tab_bar/tab_bar_view_element.dart';
import 'package:ssi_crypto_wallet/nft/nft_list.dart';
import 'package:ssi_crypto_wallet/token/view/token_list.dart';

/// StatefulWidget or StatelessWidget
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (_) => HomeCubit(),
        child: const HomePage(),
      ),

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomePageDrawer(),
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
              isTabBarShrinked:
                  context.select((HomeCubit cubit) => cubit.state),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  TabBarViewElement(TokenList(), 'Tokens'),
                  TabBarViewElement(NftList(), 'NFTs'),
                  TabBarViewElement(CredentialList(), 'SSI'),
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
