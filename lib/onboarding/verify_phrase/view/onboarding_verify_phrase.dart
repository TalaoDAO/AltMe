import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';

import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingVerifyPhrasePage extends StatelessWidget {
  const OnBoardingVerifyPhrasePage({
    required this.mnemonic,
    required this.isFromOnboarding,
    super.key,
  });

  final List<String> mnemonic;
  final bool isFromOnboarding;

  static Route<dynamic> route({
    required List<String> mnemonic,
    required bool isFromOnboarding,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => OnBoardingVerifyPhrasePage(
          mnemonic: mnemonic,
          isFromOnboarding: isFromOnboarding,
        ),
        settings: const RouteSettings(name: '/OnBoardingVerifyPhrasePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingVerifyPhraseCubit(
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        splashCubit: context.read<SplashCubit>(),
        flavorCubit: context.read<FlavorCubit>(),
        altmeChatSupportCubit: context.read<AltmeChatSupportCubit>(),
        matrixNotificationCubit: context.read<MatrixNotificationCubit>(),
        qrCodeScanCubit: context.read<QRCodeScanCubit>(),
        activityLogManager: ActivityLogManager(getSecureStorage),
        credentialsCubit: context.read<CredentialsCubit>(),
        walletCubit: context.read<WalletCubit>(),
        profileCubit: context.read<ProfileCubit>(),
        walletConnectCubit: context.read<WalletConnectCubit>(),
      ),
      child: Builder(
        builder: (context) {
          return OnBoardingVerifyPhraseView(
            mnemonic: mnemonic,
            isFromOnboarding: isFromOnboarding,
            onBoardingVerifyPhraseCubit:
                context.read<OnBoardingVerifyPhraseCubit>(),
            onboardingCubit: context.read<OnboardingCubit>(),
          );
        },
      ),
    );
  }
}

class OnBoardingVerifyPhraseView extends StatefulWidget {
  const OnBoardingVerifyPhraseView({
    required this.mnemonic,
    required this.isFromOnboarding,
    required this.onBoardingVerifyPhraseCubit,
    required this.onboardingCubit,
    super.key,
  });

  final List<String> mnemonic;
  final bool isFromOnboarding;
  final OnBoardingVerifyPhraseCubit onBoardingVerifyPhraseCubit;
  final OnboardingCubit onboardingCubit;

  @override
  State<OnBoardingVerifyPhraseView> createState() =>
      _OnBoardingVerifyPhraseViewState();
}

class _OnBoardingVerifyPhraseViewState
    extends State<OnBoardingVerifyPhraseView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onBoardingVerifyPhraseCubit.orderMnemonics();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<OnBoardingVerifyPhraseCubit,
        OnBoardingVerifyPhraseState>(
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
          if (widget.isFromOnboarding) {
            await Navigator.pushAndRemoveUntil<void>(
              context,
              WalletReadyPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          } else {
            await Navigator.pushReplacement<void, void>(
              context,
              KeyVerifiedPage.route(),
            );
          }
        }
      },
      builder: (context, state) {
        return BasePage(
          scrollView: true,
          useSafeArea: true,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceXSmall),
          titleLeading: const BackLeadingButton(),
          secureScreen: true,
          body: state.mnemonicStates.length < 12
              ? Container()
              : Column(
                  children: [
                    if (widget.isFromOnboarding) ...[
                      const MStepper(
                        step: 3,
                        totalStep: 3,
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                    ],
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
                    const SizedBox(height: Sizes.spaceSmall),
                    Text(
                      l10n.onboardingVerifyPhraseMessageDetails,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: Sizes.spaceNormal),
                    ListView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final j = 3 * index;

                        final col1Mnemonics = state.mnemonicStates[j];
                        final col2Mnemonics = state.mnemonicStates[j + 1];
                        final col3Mnemonics = state.mnemonicStates[j + 2];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: PhraseWord(
                                  key: Key(col1Mnemonics.order.toString()),
                                  order: col1Mnemonics.order,
                                  word:
                                      widget.mnemonic[col1Mnemonics.order - 1],
                                  showOrder:
                                      col1Mnemonics.mnemonicStatus.showOrder,
                                  color: col1Mnemonics.mnemonicStatus
                                      .color(context),
                                  onTap: () {
                                    widget.onBoardingVerifyPhraseCubit.verify(
                                      mnemonic: widget.mnemonic,
                                      index: j,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PhraseWord(
                                  key: Key(col2Mnemonics.order.toString()),
                                  order: col2Mnemonics.order,
                                  word:
                                      widget.mnemonic[col2Mnemonics.order - 1],
                                  showOrder:
                                      col2Mnemonics.mnemonicStatus.showOrder,
                                  color: col2Mnemonics.mnemonicStatus
                                      .color(context),
                                  onTap: () {
                                    widget.onBoardingVerifyPhraseCubit.verify(
                                      mnemonic: widget.mnemonic,
                                      index: j + 1,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PhraseWord(
                                  key: Key(col3Mnemonics.order.toString()),
                                  order: col3Mnemonics.order,
                                  word:
                                      widget.mnemonic[col3Mnemonics.order - 1],
                                  showOrder:
                                      col3Mnemonics.mnemonicStatus.showOrder,
                                  color: col3Mnemonics.mnemonicStatus
                                      .color(context),
                                  onTap: () {
                                    widget.onBoardingVerifyPhraseCubit.verify(
                                      mnemonic: widget.mnemonic,
                                      index: j + 2,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
          navigation: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.spaceSmall,
                vertical: Sizes.spaceSmall,
              ),
              child: MyElevatedButton(
                text: l10n.onBoardingGenPhraseButton,
                verticalSpacing: 18,
                onPressed: state.isVerified
                    ? () async {
                        await widget.onboardingCubit.emitOnboardingProcessing();
                        await widget.onBoardingVerifyPhraseCubit
                            .generateSSIAndCryptoAccount(
                          mnemonic: widget.mnemonic,
                          isFromOnboarding: widget.isFromOnboarding,
                        );
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
