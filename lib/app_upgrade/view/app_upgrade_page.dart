import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class AppUpgradePage extends StatelessWidget {
  const AppUpgradePage({Key? key, required this.storeInfo}) : super(key: key);

  final StoreInfo storeInfo;

  static Route route({required StoreInfo storeInfo}) => MaterialPageRoute<void>(
        builder: (_) => AppUpgradePage(storeInfo: storeInfo),
        settings: const RouteSettings(name: '/AppUpgradePage'),
      );

  @override
  Widget build(BuildContext context) {
    return AppUpgradeView(storeInfo: storeInfo);
  }
}

class AppUpgradeView extends StatelessWidget {
  const AppUpgradeView({
    Key? key,
    required this.storeInfo,
  }) : super(key: key);

  final StoreInfo storeInfo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async => false,
      child: BasePage(
        scrollView: false,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                ImageStrings.splashImage,
                fit: BoxFit.fitWidth,
                height: MediaQuery.of(context).size.longestSide * 0.3,
              ),
              const SizedBox(height: 30),
              Text(
                'Time to update',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Text(
                '''We have added lots of features and fixed some bugs to make your experience as much as possible.''',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                '''A new version of Altme is avaible! You can now update this app from v${storeInfo.localVersion} to v${storeInfo.storeVersion}.''',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
              if (storeInfo.releaseNotes.isNotEmpty) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (context) => InfoDialog(
                        title: storeInfo.releaseNotes,
                        button: l10n.ok,
                      ),
                    );
                  },
                  child: Text(
                    "What's new in v${storeInfo.storeVersion}?",
                    style: Theme.of(context).textTheme.copyToClipBoard,
                  ),
                ),
              ],
              const SizedBox(height: 30),
              MyGradientButton(
                onPressed: () {},
                text: 'Update Now',
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<CredentialModel>>(
                future: CredentialsRepository(getSecureStorage).findAll(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      final credentials = snapshot.data ?? [];

                      if (credentials.isNotEmpty) {
                        return TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push<void>(BackupCredentialPage.route());
                          },
                          child: Text(
                            'Backup your Credential',
                            style: Theme.of(context).textTheme.copyToClipBoard,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    case ConnectionState.active:
                      return const SizedBox();
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
