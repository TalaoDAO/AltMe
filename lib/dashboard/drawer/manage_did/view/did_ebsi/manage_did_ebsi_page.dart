import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageDidEbsiPage extends StatefulWidget {
  const ManageDidEbsiPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(builder: (_) => const ManageDidEbsiPage());
  }

  @override
  State<ManageDidEbsiPage> createState() => _ManageDidEbsiPageState();
}

class _ManageDidEbsiPageState extends State<ManageDidEbsiPage> {
  String did = '';
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final ebsi = Ebsi(Dio());
      //final mnemonic =
      // await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
      final String p256PrivateKey =
          await getRandomP256PrivateKey(getSecureStorage);
      did = await ebsi.getDidFromMnemonic(null, p256PrivateKey);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.manageEbsiDecentralizedId,
      titleAlignment: Alignment.topCenter,
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Did(did: did),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.spaceNormal),
              child: Divider(),
            ),
            DidPrivateKey(
              l10n: l10n,
              route: DidEbsiPrivateKeyPage.route(),
            ),
          ],
        ),
      ),
    );
  }
}
