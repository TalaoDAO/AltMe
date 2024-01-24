import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageDIDEdDSAPage extends StatefulWidget {
  const ManageDIDEdDSAPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ManageDIDEdDSAPage(),
      settings: const RouteSettings(name: '/ManageDIDEdDSAPage'),
    );
  }

  @override
  State<ManageDIDEdDSAPage> createState() => _ManageDIDEdDSAPageState();
}

class _ManageDIDEdDSAPageState extends State<ManageDIDEdDSAPage> {
  Future<String> getDid() async {
    const didMethod = AltMeStrings.defaultDIDMethod;
    final ssiKey = await getSecureStorage.get(SecureStorageKeys.ssiKey);
    final did = DIDKitProvider().keyToDID(didMethod, ssiKey!);

    return did;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.keyDecentralizedIdEdSA,
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
            DidPrivateKey(route: DIDEdDSAPrivateKeyPage.route()),
          ],
        ),
      ),
    );
  }
}
