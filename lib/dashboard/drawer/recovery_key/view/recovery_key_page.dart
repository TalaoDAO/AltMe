import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/recovery_key/cubit/recovery_key_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_application/secure_application.dart';
import 'package:secure_storage/secure_storage.dart';

class RecoveryKeyPage extends StatelessWidget {
  const RecoveryKeyPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const RecoveryKeyPage(),
        settings: const RouteSettings(name: '/recoveryKeyPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecoveryKeyCubit(
        secureStorageProvider: getSecureStorage,
        walletCubit: context.read<WalletCubit>(),
      ),
      child: const RecoveryKeyView(),
    );
  }
}

class RecoveryKeyView extends StatefulWidget {
  const RecoveryKeyView({Key? key}) : super(key: key);

  @override
  State<RecoveryKeyView> createState() => _RecoveryKeyViewState();
}

class _RecoveryKeyViewState extends State<RecoveryKeyView>
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
    print(state);
    if (state == AppLifecycleState.inactive) {
      secureApplicationController.lock();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
            title: l10n.recoveryKeyTitle,
            titleAlignment: Alignment.topCenter,
            titleLeading: const BackLeadingButton(),
            scrollView: false,
            body: BlocBuilder<RecoveryKeyCubit, RecoveryKeyState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          l10n.genPhraseInstruction,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.messageTitle,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.genPhraseExplanation,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.messageSubtitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (state.mnemonic != null && state.mnemonic!.isNotEmpty)
                      MnemonicDisplay(mnemonic: state.mnemonic!),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
