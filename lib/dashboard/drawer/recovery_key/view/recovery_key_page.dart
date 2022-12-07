import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/recovery_key/cubit/recovery_key_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class RecoveryKeyView extends StatelessWidget {
  const RecoveryKeyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
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
    );
  }
}
