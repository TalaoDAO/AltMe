import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
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
        drawer: DrawerPage(
          scaffoldKey: scaffoldKey,
        ),
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
        body: const TabControllerWidget(),
      ),
    );
  }
}
