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
import 'package:secure_application/secure_application.dart';
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

class _BackupCredentialViewState extends State<BackupCredentialView>
    with WidgetsBindingObserver {
  final SecureApplicationController secureApplicationController =
      SecureApplicationController(
    SecureApplicationState(secured: true, authenticated: true),
  );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      secureApplicationController.lock();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() => context.read<DIDPrivateKeyCubit>().initialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SecureApplication(
      nativeRemoveDelay: 800,
      autoUnlockNative: true,
      secureApplicationController: secureApplicationController,
      onNeedUnlock: (secureApplicationController) async {
        /// need unlock maybe use biometric to confirm and then sercure.unlock()
        /// or you can use the lockedBuilder

        secureApplicationController!.authSuccess(unlock: true);
        return SecureApplicationAuthenticationStatus.SUCCESS;
        //return null;
      },
      child: Builder(builder: (context) {
        return SecureGate(
          blurr: Parameters.blurr,
          opacity: Parameters.opacity,
          lockedBuilder: (context, secureNotifier) => Container(),
          child: BasePage(
            title: l10n.backupCredential,
            titleAlignment: Alignment.topCenter,
            titleLeading: const BackLeadingButton(),
            padding: const EdgeInsets.only(
              top: 0,
              bottom: Sizes.spaceSmall,
              left: Sizes.spaceSmall,
              right: Sizes.spaceSmall,
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
                    if (state.mnemonic != null)
                      MnemonicDisplay(mnemonic: state.mnemonic!),
                  ],
                );
              },
            ),
            navigation: Padding(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              child: BlocBuilder<BackupCredentialCubit, BackupCredentialState>(
                builder: (context, state) {
                  return MyGradientButton(
                    onPressed: state.mnemonic == null
                        ? null
                        : () {
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
          ),
        );
      }),
    );
  }
}
