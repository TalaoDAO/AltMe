import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/home/home/widgets/tab_bar.dart';
import 'package:altme/home/tokens/view/token_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
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
        padding: EdgeInsets.zero,
        titleLeading: IconButton(
          icon: ImageIcon(
            const AssetImage(IconStrings.icMenu),
            color: Theme.of(context).colorScheme.leadingButton,
          ),
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
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const [0.3, 1.0],
                    ),
                  ),
                  automaticIndicatorColorAdjustment: false,
                  labelColor: Theme.of(context).colorScheme.label,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.unSelectedLabel,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  tabs: [
                    MyTab(
                      text: l10n.cards,
                      icon: IconStrings.userSquare,
                    ),
                    MyTab(
                      text: l10n.nfts,
                      icon: IconStrings.ghost,
                    ),
                    MyTab(
                      text: l10n.tokens,
                      icon: IconStrings.health,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BackgroundCard(
                    child: TabBarView(
                      children: [
                        CredentialsListPage(),
                        NftPage(),
                        TokenPage(),
                      ],
                    ),
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
