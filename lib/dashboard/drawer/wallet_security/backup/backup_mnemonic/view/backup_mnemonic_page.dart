import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';

import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class BackupMnemonicPage extends StatelessWidget {
  const BackupMnemonicPage({
    super.key,
    required this.isValidCallback,
    required this.title,
  });

  final VoidCallback isValidCallback;
  final String title;

  static Route<dynamic> route({
    required VoidCallback isValidCallback,
    required String title,
  }) => MaterialPageRoute<void>(
    builder: (_) =>
        BackupMnemonicPage(isValidCallback: isValidCallback, title: title),
    settings: const RouteSettings(name: '/BackupMnemonicPage'),
  );

  @override
  Widget build(BuildContext context) {
    return BackupMnemonicView(isValidCallback: isValidCallback, title: title);
  }
}

class BackupMnemonicView extends StatelessWidget {
  const BackupMnemonicView({
    super.key,
    required this.isValidCallback,
    required this.title,
  });

  final VoidCallback isValidCallback;
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: title,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        bottom: Sizes.spaceSmall,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
      ),
      secureScreen: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const MStepper(totalStep: 2, step: 1),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.backupCredentialPhraseExplanation,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 32),
          FutureBuilder<List<String>>(
            future: getssiMnemonicsInList(getSecureStorage),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final mnemonics = snapshot.data!;
                  return MnemonicDisplay(mnemonic: mnemonics);
                case ConnectionState.waiting:
                case ConnectionState.none:
                case ConnectionState.active:
                  return const SizedBox();
              }
            },
          ),
        ],
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: MyElevatedButton(
          onPressed: isValidCallback.call,
          text: l10n.next,
        ),
      ),
    );
  }
}
