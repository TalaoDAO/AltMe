import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/credentials/detail/view/search.dart';
import 'package:altme/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/qr_code/qr_code.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsListPage extends StatefulWidget {
  const CredentialsListPage({
    Key? key,
  }) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const CredentialsListPage(),
        settings: const RouteSettings(name: '/CredentialsListPage'),
      );

  @override
  State<CredentialsListPage> createState() => _CredentialsListPageState();
}

class _CredentialsListPageState extends State<CredentialsListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      /// If there is a deepLink we give do as if it coming from QRCode
      context.read<QRCodeScanCubit>().deepLink();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext credentialListContext) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: BasePage(
        scaffoldKey: scaffoldKey,
        title: l10n.credentialListTitle,
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        drawer: const ProfilePage(),
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
        body: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            var _credentialList = <CredentialModel>[];
            _credentialList = state.credentials;
            return Column(
              children: [
                const Search(),
                ...List.generate(
                  _credentialList.length,
                  (index) => CredentialsListPageItem(
                    credentialModel: _credentialList[index],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
