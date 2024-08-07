import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetWalletMenu extends StatelessWidget {
  const ResetWalletMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ResetWalletMenu(),
      settings: const RouteSettings(name: '/ResetWalletMenu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetWalletCubit>(
      create: (_) => ResetWalletCubit(),
      child: const ResetWalletView(),
    );
  }
}

class ResetWalletView extends StatelessWidget {
  const ResetWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.resetWallet,
      useSafeArea: true,
      scrollView: false,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      titleLeading: const BackLeadingButton(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<ResetWalletCubit, ResetWalletState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                l10n.resetWalletTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: Sizes.spaceNormal,
              ),
              Text(
                l10n.resetWalletSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: Sizes.spaceLarge,
              ),
              Text(
                l10n.resetWalletSubtitle2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              CheckboxItem(
                value: state.isRecoveryPhraseWritten,
                text: l10n.resetWalletCheckBox1,
                onChange: (_) {
                  context
                      .read<ResetWalletCubit>()
                      .toggleIsRecoveryPhraseWritten();
                },
              ),
              const SizedBox(
                height: Sizes.spaceSmall,
              ),
              CheckboxItem(
                value: state.isBackupCredentialSaved,
                text: l10n.resetWalletCheckBox2,
                onChange: (_) {
                  context
                      .read<ResetWalletCubit>()
                      .toggleIsBackupCredentialSaved();
                },
              ),
            ],
          );
        },
      ),
      navigation: BlocBuilder<ResetWalletCubit, ResetWalletState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: MyElevatedButton(
              text: l10n.resetWallet,
              onPressed:
                  state.isBackupCredentialSaved && state.isRecoveryPhraseWritten
                      ? () async {
                          await securityCheck(
                            context: context,
                            localAuthApi: LocalAuthApi(),
                            onSuccess: () async {
                              await resetWallet(context);
                            },
                          );
                        }
                      : null,
            ),
          );
        },
      ),
    );
  }
}
