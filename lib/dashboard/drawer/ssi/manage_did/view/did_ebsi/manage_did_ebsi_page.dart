import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageDidEbsiPage extends StatefulWidget {
  const ManageDidEbsiPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ManageDidEbsiPage(),
      settings: const RouteSettings(name: '/ManageDidEbsiPage'),
    );
  }

  @override
  State<ManageDidEbsiPage> createState() => _ManageDidEbsiPageState();
}

class _ManageDidEbsiPageState extends State<ManageDidEbsiPage> {
  Future<String> getDid() async {
    final oidc4vc =
        context.read<ProfileCubit>().state.model.oidc4vcType.getOIDC4VC;
    final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
    final privateKey =
        await oidc4vc.privateKeyFromMnemonic(mnemonic: mnemonic!);
    final did = await oidc4vc.getDidFromMnemonic(null, privateKey);
    return did;
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
            DidPrivateKey(route: DidEbsiPrivateKeyPage.route()),
          ],
        ),
      ),
    );
  }
}
