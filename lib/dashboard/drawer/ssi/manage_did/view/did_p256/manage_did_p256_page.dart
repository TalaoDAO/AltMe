import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageDidP256Page extends StatefulWidget {
  const ManageDidP256Page({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ManageDidP256Page(),
      settings: const RouteSettings(name: '/ManageDidP256Page'),
    );
  }

  @override
  State<ManageDidP256Page> createState() => _ManageDidP256PageState();
}

class _ManageDidP256PageState extends State<ManageDidP256Page> {
  Future<String> getDid() async {
    final privateKey = await getP256PrivateKey(getSecureStorage);

    final (did, _) = await getDidAndKid(
      isEBSIV3: false,
      privateKey: privateKey,
      didKitProvider: DIDKitProvider(),
      secureStorage: getSecureStorage,
    );

    return did;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.keyDecentralizedIDP256,
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
            DidPrivateKey(route: DidP256PrivateKeyPage.route()),
          ],
        ),
      ),
    );
  }
}
