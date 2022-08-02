import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/secret_key/cubit/secret_key_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecretKeyPage extends StatelessWidget {
  const SecretKeyPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const SecretKeyPage(),
        settings: const RouteSettings(name: '/secretKeyPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SecretKeyCubit(
        walletCubit: context.read<WalletCubit>(),
      ),
      child: const SecretKeyView(),
    );
  }
}

class SecretKeyView extends StatelessWidget {
  const SecretKeyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.secretKey,
      titleLeading: const BackLeadingButton(),
      body: BlocBuilder<SecretKeyCubit, String>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: state));
                  },
                  child: Text(l10n.copySecretKeyToClipboard),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
