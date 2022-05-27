import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class BackupCredentialPage extends StatefulWidget {
  const BackupCredentialPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (context) => BackupCredentialCubit(
            secureStorageProvider: getSecureStorage,
            cryptoKeys: const CryptocurrencyKeys(),
            walletCubit: context.read<WalletCubit>(),
            fileSaver: FileSaver.instance,
          ),
          child: const BackupCredentialPage(),
        ),
        settings: const RouteSettings(name: '/backupCredentialPage'),
      );

  @override
  State<BackupCredentialPage> createState() => _BackupCredentialPageState();
}

class _BackupCredentialPageState extends State<BackupCredentialPage> {
  OverlayEntry? _overlay;

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
              _overlay = OverlayEntry(
                builder: (_) => const LoadingDialog(),
              );
              Overlay.of(context)!.insert(_overlay!);
            } else {
              if (_overlay != null) {
                _overlay!.remove();
                _overlay = null;
              }
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
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.backupCredentialPhraseExplanation,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                MnemonicDisplay(mnemonic: state.mnemonic),
                const SizedBox(height: 32),
                SizedBox(
                  height: 42,
                  child: BaseButton.primary(
                    context: context,
                    onPressed: state.status == AppStatus.loading
                        ? null
                        : () async {
                            await context
                                .read<BackupCredentialCubit>()
                                .encryptAndDownloadFile();
                          },
                    child: Text(l10n.backupCredentialButtonTitle),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
