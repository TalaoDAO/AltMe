import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
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
      child: BlocConsumer<OnBoardingGenPhraseCubit, OnBoardingGenPhraseState>(
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
          return BasePage(
            title: l10n.onbordingSeedPhrase,
            scrollView: false,
            useSafeArea: true,
            titleLeading: BackLeadingButton(
              onPressed: () {
                if (context.read<OnBoardingGenPhraseCubit>().state.status !=
                    AppStatus.loading) {
                  Navigator.of(context).pop();
                }
              },
            ),
            body: BackgroundCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            l10n.onboardingPleaseStoreMessage,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.passPhraseMessage,
                          ),
                          const SizedBox(height: Sizes.spaceNormal),
                          Text(
                            l10n.onboardingAltmeMessage,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .passPhraseSubMessage,
                          ),
                          const SizedBox(height: Sizes.spaceNormal),
                          MnemonicDisplay(mnemonic: state.mnemonic),
                          const SizedBox(
                            height: Sizes.spaceNormal,
                          ),
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
                              style:
                                  Theme.of(context).textTheme.copyToClipBoard,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.spaceSmall,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: Sizes.icon,
                          width: Sizes.icon,
                          margin: const EdgeInsets.symmetric(
                            vertical: Sizes.space2XSmall,
                            horizontal: Sizes.spaceXSmall,
                          ),
                          child: Checkbox(
                            value: state.isTicked,
                            fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            onChanged: (newValue) => context
                                .read<OnBoardingGenPhraseCubit>()
                                .switchTick(),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<OnBoardingGenPhraseCubit>()
                                  .switchTick();
                            },
                            child: Text(
                              l10n.onboardingWroteDownMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .onBoardingCheckMessage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            navigation: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
                child: MyGradientButton(
                  text: l10n.onBoardingGenPhraseButton,
                  verticalSpacing: 16,
                  onPressed: state.isTicked
                      ? () async {
                          await context
                              .read<OnBoardingGenPhraseCubit>()
                              .generateSSIAndCryptoAccount(state.mnemonic);
                        }
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
