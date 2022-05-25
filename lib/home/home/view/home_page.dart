import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const HomePage(),
        settings: const RouteSettings(name: '/homePage'),
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      /// If there is a deepLink we give do as if it coming from QRCode
      context.read<QRCodeScanCubit>().deepLink();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: BasePage(
        scrollView: false,
        scaffoldKey: scaffoldKey,
        drawer: const DrawerPage(),
        titleLeading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        titleTrailing: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: () {
            if (kIsWeb) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) => InfoDialog(
                  title: l10n.unavailable_feature_title,
                  subtitle: l10n.unavailable_feature_message,
                  button: l10n.ok,
                ),
              );
            } else {
              Navigator.of(context).push<void>(QrCodeScanPage.route());
            }
          },
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    // TODO(bibash): localise
                    Tab(
                      text: 'Cards',
                    ),
                    Tab(
                      text: 'NFTs',
                    ),
                    Tab(
                      text: 'Tokens',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Expanded(
                child: BackgroundCard(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TabBarView(
                    children: [
                      CredentialsListPage(),
                      NftPage(),
                      Center(
                        child: Text('Tokens'),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
