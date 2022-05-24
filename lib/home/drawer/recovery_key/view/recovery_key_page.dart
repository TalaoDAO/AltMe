import 'package:altme/app/app.dart';
import 'package:altme/home/drawer/recovery_key/cubit/recovery_key_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class RecoveryKeyPage extends StatefulWidget {
  const RecoveryKeyPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (context) => RecoveryKeyCubit(
            secureStorageProvider: getSecureStorage,
          ),
          child: const RecoveryKeyPage(),
        ),
        settings: const RouteSettings(name: '/recoveryKeyPage'),
      );

  @override
  State<RecoveryKeyPage> createState() => _RecoveryKeyPageState();
}

class _RecoveryKeyPageState extends State<RecoveryKeyPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.recoveryKeyTitle,
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.genPhraseExplanation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
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
