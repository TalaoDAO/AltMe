import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingVerifyPhrasePage extends StatelessWidget {
  const OnBoardingVerifyPhrasePage({required this.mnemonic, super.key});

  final List<String> mnemonic;

  static Route<dynamic> route({required List<String> mnemonic}) =>
      MaterialPageRoute<void>(
        builder: (context) => OnBoardingVerifyPhrasePage(mnemonic: mnemonic),
        settings: const RouteSettings(name: '/OnBoardingVerifyPhrasePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingVerifyPhraseCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
        splashCubit: context.read<SplashCubit>(),
      ),
      child: OnBoardingVerifyPhraseView(mnemonic: mnemonic),
    );
  }
}

class OnBoardingVerifyPhraseView extends StatelessWidget {
  OnBoardingVerifyPhraseView({required this.mnemonic, super.key});

  final fourthLastController = TextEditingController();
  final thirdLastController = TextEditingController();
  final secondLastController = TextEditingController();
  final lastController = TextEditingController();

  final List<String> mnemonic;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<OnBoardingVerifyPhraseCubit,
        OnBoardingVerifyPhraseState>(
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
          context.read<LiveChatCubit>().init();
          Navigator.pushAndRemoveUntil<void>(
            context,
            WalletReadyPage.route(),
            (Route<dynamic> route) => route.isFirst,
          );
        }
      },
      builder: (context, state) {
        return BasePage(
          scrollView: false,
          useSafeArea: true,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceXSmall),
          titleLeading: const BackLeadingButton(),
          secureScreen: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const MStepper(
                        step: 4,
                        totalStep: 4,
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.spaceNormal,
                        ),
                        child: Text(
                          l10n.onboardingVerifyPhraseMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      const SizedBox(height: Sizes.spaceSmall),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: PhraseWord(order: 1, word: mnemonic[0]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PhraseWord(order: 2, word: mnemonic[1]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PhraseWord(order: 3, word: mnemonic[2]),
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: PhraseWord(order: 4, word: mnemonic[3]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PhraseWord(order: 5, word: mnemonic[4]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PhraseWord(order: 6, word: mnemonic[5]),
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: PhraseWord(order: 7, word: mnemonic[6]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PhraseWord(order: 8, word: mnemonic[7]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MnemonicTextField(
                              controller: fourthLastController,
                              onChanged: (value) {
                                context
                                    .read<OnBoardingVerifyPhraseCubit>()
                                    .verify(
                                  mnemonic: mnemonic,
                                  lastFourMnemonics: [
                                    fourthLastController.text,
                                    thirdLastController.text,
                                    secondLastController.text,
                                    lastController.text,
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      Row(
                        children: [
                          Expanded(
                            child: MnemonicTextField(
                              controller: thirdLastController,
                              onChanged: (value) {
                                context
                                    .read<OnBoardingVerifyPhraseCubit>()
                                    .verify(
                                  mnemonic: mnemonic,
                                  lastFourMnemonics: [
                                    fourthLastController.text,
                                    value,
                                    secondLastController.text,
                                    lastController.text,
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MnemonicTextField(
                              controller: secondLastController,
                              onChanged: (value) {
                                context
                                    .read<OnBoardingVerifyPhraseCubit>()
                                    .verify(
                                  mnemonic: mnemonic,
                                  lastFourMnemonics: [
                                    fourthLastController.text,
                                    thirdLastController.text,
                                    value,
                                    lastController.text,
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MnemonicTextField(
                              controller: lastController,
                              onChanged: (value) {
                                context
                                    .read<OnBoardingVerifyPhraseCubit>()
                                    .verify(
                                  mnemonic: mnemonic,
                                  lastFourMnemonics: [
                                    fourthLastController.text,
                                    thirdLastController.text,
                                    secondLastController.text,
                                    value,
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceLarge),
                      const SizedBox(height: Sizes.spaceSmall),
                      Text(
                        l10n.onboardingAltmeMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.genPhraseSubmessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          navigation: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.spaceSmall,
                vertical: Sizes.spaceSmall,
              ),
              child: MyGradientButton(
                text: l10n.onBoardingGenPhraseButton,
                verticalSpacing: 18,
                onPressed: state.isVerified
                    ? () async {
                        await context
                            .read<OnBoardingVerifyPhraseCubit>()
                            .generateSSIAndCryptoAccount(mnemonic);
                      }
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
