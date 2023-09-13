import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageDidSecp256k1Page extends StatefulWidget {
  const ManageDidSecp256k1Page({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ManageDidSecp256k1Page(),
      settings: const RouteSettings(name: '/ManageDidSecp256k1Page'),
    );
  }

  @override
  State<ManageDidSecp256k1Page> createState() => _ManageDidEbsiPageState();
}

class _ManageDidEbsiPageState extends State<ManageDidSecp256k1Page> {
  Future<String> getDid() async {
    final oidc4vc = OIDC4VCType.DEFAULT.getOIDC4VC;
    final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);

    final privateKey = await oidc4vc.privateKeyFromMnemonic(
      mnemonic: mnemonic!,
      indexValue: OIDC4VCType.DEFAULT.indexValue,
    );

    const didMethod = AltMeStrings.defaultDIDMethod;
    final did = DIDKitProvider().keyToDID(didMethod, privateKey);
    return did;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.manageKeyDecentralizedIDSecp256k1,
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
            FutureBuilder<String>(
              future: getDid(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    final did = snapshot.data!;
                    return Did(did: did);
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  case ConnectionState.active:
                    return const SizedBox();
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.spaceNormal),
              child: Divider(),
            ),
            DidPrivateKey(route: DidSecp256k1PrivateKeyPage.route()),
          ],
        ),
      ),
    );
  }
}
