import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
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

class BackupCredentialView extends StatelessWidget {
  const BackupCredentialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async {
        if (context.read<BackupCredentialCubit>().state.status ==
            AppStatus.loading) {
          return false;
        }
        return true;
      },
      child: BasePage(
        title: l10n.backupCredential,
        titleAlignment: Alignment.topCenter,
        titleLeading: BackLeadingButton(
          onPressed: () {
            if (context.read<BackupCredentialCubit>().state.status !=
                AppStatus.loading) {
              Navigator.of(context).pop();
            }
          },
        ),
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
                    Text(
                      l10n.backupCredentialPhrase,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.messageTitle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.backupCredentialPhraseExplanation,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.messageSubtitle,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (state.mnemonic != null)
                  MnemonicDisplay(mnemonic: state.mnemonic!),
                const SizedBox(height: 32),
                MyGradientButton(
                  onPressed: () async {
                    await context
                        .read<BackupCredentialCubit>()
                        .encryptAndDownloadFile();
                  },
                  text: l10n.backupCredentialButtonTitle,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
