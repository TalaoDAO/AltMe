import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageDidEbsiV3Page extends StatefulWidget {
  const ManageDidEbsiV3Page({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ManageDidEbsiV3Page(),
      settings: const RouteSettings(name: '/ManageDidEbsiV3Page'),
    );
  }

  @override
  State<ManageDidEbsiV3Page> createState() => _ManageDidEbsiPageState();
}

class _ManageDidEbsiPageState extends State<ManageDidEbsiV3Page> {
  Future<String> getDid() async {
    final privateKey = await fetchPrivateKey(
      isEBSIV3: true,
      oidc4vc: OIDC4VC(),
      secureStorage: getSecureStorage,
    );

    final (did, _) = await getDidAndKid(
      isEBSIV3: true,
      privateKey: privateKey,
      secureStorage: getSecureStorage,
    );

    return did;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.manageEbsiV3DecentralizedId,
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
            DidPrivateKey(route: DidEbsiV3PrivateKeyPage.route()),
          ],
        ),
      ),
    );
  }
}
