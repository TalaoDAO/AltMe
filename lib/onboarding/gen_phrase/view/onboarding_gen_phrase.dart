import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/gen_phrase/cubit/onboarding_gen_phrase_cubit.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingGenPhrasePage extends StatelessWidget {
  const OnBoardingGenPhrasePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingGenPhrasePage(),
        settings: const RouteSettings(name: '/onBoardingGenPhrasePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingGenPhraseCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
      ),
      child: const OnBoardingGenPhraseView(),
    );
  }
}

class OnBoardingGenPhraseView extends StatelessWidget {
  const OnBoardingGenPhraseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async {
        if (context.read<OnBoardingGenPhraseCubit>().state.status ==
            AppStatus.loading) {
          return false;
        }
        return true;
      },
      child: BasePage(
        title: l10n.onbordingSeedPhrase,
        titleLeading: BackLeadingButton(
          onPressed: () {
            if (context.read<OnBoardingGenPhraseCubit>().state.status !=
                AppStatus.loading) {
              Navigator.of(context).pop();
            }
          },
        ),
        scrollView: true,
        body: BlocConsumer<OnBoardingGenPhraseCubit, OnBoardingGenPhraseState>(
          listener: (context, state) {
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
            if (state.status == AppStatus.success) {
              /// Removes every stack except first route (splashPage)
              Navigator.pushAndRemoveUntil<void>(
                context,
                HomePage.route(),
                (Route<dynamic> route) => route.isFirst,
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      l10n.onboardingPleaseStoreMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.passPhraseMessage,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.onboardingAltmeMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.passPhraseSubMessage,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                MnemonicDisplay(mnemonic: state.mnemonic),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: state.mnemonic.join(' '),
                      ),
                    );
                  },
                  child: Text(
                    l10n.copyToClipboard,
                    style: Theme.of(context).textTheme.copyToClipBoard,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      context.read<OnBoardingGenPhraseCubit>().switchTick();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          state.isTicked
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            l10n.onboardingWroteDownMessage,
                            style: Theme.of(context)
                                .textTheme
                                .onBoardingCheckMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                MyGradientButton(
                  text: l10n.onBoardingGenPhraseButton,
                  verticalSpacing: 14,
                  onPressed: state.isTicked
                      ? () async {
                          await context
                              .read<OnBoardingGenPhraseCubit>()
                              .generateSSIAndCryptoAccount(state.mnemonic);
                        }
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
