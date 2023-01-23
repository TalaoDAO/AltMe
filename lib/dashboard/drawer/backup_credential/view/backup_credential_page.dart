import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class BackupCredentialPage extends StatelessWidget {
  const BackupCredentialPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const BackupCredentialPage(),
        settings: const RouteSettings(name: '/backupCredentialPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BackupCredentialCubit(
        secureStorageProvider: getSecureStorage,
        cryptoKeys: const CryptocurrencyKeys(),
        walletCubit: context.read<WalletCubit>(),
        fileSaver: FileSaver.instance,
      ),
      child: const BackupCredentialView(),
    );
  }
}

class BackupCredentialView extends StatefulWidget {
  const BackupCredentialView({Key? key}) : super(key: key);

  @override
  State<BackupCredentialView> createState() => _BackupCredentialViewState();
}

class _BackupCredentialViewState extends State<BackupCredentialView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.backupCredential,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        bottom: Sizes.spaceSmall,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
      ),
      secureScreen: true,
      body: BlocConsumer<BackupCredentialCubit, BackupCredentialState>(
        listener: (context, state) async {
          if (state.status == AppStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (state.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const MStepper(
                    totalStep: 2,
                    step: 1,
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                  Text(
                    l10n.backupCredentialPhraseExplanation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.messageTitle,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              FutureBuilder<List<String>>(
                future: context.read<BackupCredentialCubit>().loadMnemonic(),
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
              )
            ],
          );
        },
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: BlocBuilder<BackupCredentialCubit, BackupCredentialState>(
          builder: (context, state) {
            return MyGradientButton(
              onPressed: () {
                if (context.read<BackupCredentialCubit>().mnemonics == null) {
                  return;
                }
                Navigator.of(context).push<void>(
                  SaveBackupCredentialPage.route(
                    backupCredentialCubit:
                        context.read<BackupCredentialCubit>(),
                  ),
                );
              },
              text: l10n.next,
            );
          },
        ),
      ),
    );
  }
}
