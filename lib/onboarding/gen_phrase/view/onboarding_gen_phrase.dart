import 'package:altme/activity_log/activity_log_manager.dart';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';

import 'package:altme/wallet/wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingGenPhrasePage extends StatelessWidget {
  const OnBoardingGenPhrasePage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingGenPhrasePage(),
        settings: const RouteSettings(name: '/onBoardingGenPhrasePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingGenPhraseCubit(
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
        splashCubit: context.read<SplashCubit>(),
        altmeChatSupportCubit: context.read<AltmeChatSupportCubit>(),
        matrixNotificationCubit: context.read<MatrixNotificationCubit>(),
        profileCubit: context.read<ProfileCubit>(),
        activityLogManager: ActivityLogManager(getSecureStorage),
      ),
      child: const OnBoardingGenPhraseView(),
    );
  }
}

class OnBoardingGenPhraseView extends StatefulWidget {
  const OnBoardingGenPhraseView({super.key});

  @override
  State<OnBoardingGenPhraseView> createState() =>
      _OnBoardingGenPhraseViewState();
}

class _OnBoardingGenPhraseViewState extends State<OnBoardingGenPhraseView> {
  late List<String>? mnemonic;

  @override
  void initState() {
    super.initState();
    mnemonic = bip39.generateMnemonic().split(' ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<OnBoardingGenPhraseCubit, OnBoardingGenPhraseState>(
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

        if (state.status == AppStatus.success) {
          await Navigator.pushAndRemoveUntil<void>(
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
                        step: 3,
                        totalStep: 3,
                      ),
                      const SizedBox(
                        height: Sizes.spaceNormal,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.spaceNormal,
                        ),
                        child: Text(
                          l10n.onboardingPleaseStoreMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      if (mnemonic != null)
                        MnemonicDisplay(mnemonic: mnemonic!),
                      const SizedBox(height: Sizes.spaceLarge),
                      Text(
                        l10n.onboardingAltmeMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyOutlinedButton(
                    text: l10n.verifyLater,
                    verticalSpacing: 18,
                    onPressed: () async {
                      await context
                          .read<OnboardingCubit>()
                          .emitOnboardingProcessing();
                      await context
                          .read<OnBoardingGenPhraseCubit>()
                          .generateSSIAndCryptoAccount(
                            mnemonic: mnemonic!,
                            restoreWallet: false,
                          );
                    },
                  ),
                  const SizedBox(height: 10),
                  MyElevatedButton(
                    text: l10n.verifyNow,
                    verticalSpacing: 18,
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        OnBoardingVerifyPhrasePage.route(
                          mnemonic: mnemonic!,
                          isFromOnboarding: true,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
