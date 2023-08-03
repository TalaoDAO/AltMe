import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/initiate_oidv4vc_credential_issuance.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageDidEbsiV2Page extends StatefulWidget {
  const ManageDidEbsiV2Page({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ManageDidEbsiV2Page(),
      settings: const RouteSettings(name: '/ManageDidEbsiV2Page'),
    );
  }

  @override
  State<ManageDidEbsiV2Page> createState() => _ManageDidEbsiPageState();
}

class _ManageDidEbsiPageState extends State<ManageDidEbsiV2Page> {
  Future<String> getDid() async {
    final oidc4vc = OIDC4VCType.EBSIV2.getOIDC4VC;
    final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);

    final privateKey = await oidc4vc.privateKeyFromMnemonic(
      mnemonic: mnemonic!,
      index: OIDC4VCType.EBSIV2.index,
    );

    final private = await oidc4vc.getPrivateKey(mnemonic, privateKey);

    final thumbprint = getThumbprint(private);
    final encodedAddress = Base58Encode([2, ...thumbprint]);
    return 'did:ebsi:z$encodedAddress';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.manageEbsiV2DecentralizedId,
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
            DidPrivateKey(route: DidEbsiV2PrivateKeyPage.route()),
          ],
        ),
      ),
    );
  }
}
