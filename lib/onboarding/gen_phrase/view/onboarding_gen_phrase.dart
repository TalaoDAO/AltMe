import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingGenPhrasePage extends StatelessWidget {
  const OnBoardingGenPhrasePage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingGenPhrasePage(),
        settings: const RouteSettings(name: '/onBoardingGenPhrasePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingGenPhraseCubit(),
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
    Future.microtask(() => context.read<DIDPrivateKeyCubit>().initialize())
        .catchError((_) => null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<OnBoardingGenPhraseCubit, OnBoardingGenPhraseState>(
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
                        step: 3,
                        totalStep: 4,
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
                      // const SizedBox(
                      //   height: Sizes.spaceSmall,
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     Clipboard.setData(
                      //       ClipboardData(
                      //         text: state.mnemonic.join(' '),
                      //       ),
                      //     );
                      //   },
                      //   child: Text(
                      //     l10n.copyToClipboard,
                      //     style: Theme.of(context).textTheme.copyToClipBoard,
                      //   ),
                      // ),
                      const SizedBox(height: Sizes.spaceLarge),
                      Text(
                        l10n.onboardingAltmeMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.genPhraseSubmessage,
                      ),
                    ],
                  ),
                ),
              ),
              //const Spacer(),
              Padding(
                padding: const EdgeInsets.all(
                  Sizes.spaceNormal,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: state.isTicked,
                        fillColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                    const SizedBox(
                      width: Sizes.spaceXSmall,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<OnBoardingGenPhraseCubit>().switchTick();
                        },
                        child: MyText(
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
          navigation: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.spaceSmall,
                vertical: Sizes.spaceSmall,
              ),
              child: MyGradientButton(
                text: l10n.onBoardingGenPhraseButton,
                verticalSpacing: 18,
                onPressed: state.isTicked
                    ? () {
                        Navigator.of(context).push(
                          OnBoardingVerifyPhrasePage.route(
                            mnemonic: mnemonic!,
                          ),
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
