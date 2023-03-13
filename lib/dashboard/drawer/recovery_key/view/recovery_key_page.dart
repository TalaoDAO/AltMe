import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class RecoveryKeyPage extends StatelessWidget {
  const RecoveryKeyPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (_) => const RecoveryKeyPage(),
        settings: const RouteSettings(name: '/recoveryKeyPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecoveryKeyCubit(
        secureStorageProvider: getSecureStorage,
      ),
      child: const RecoveryKeyView(),
    );
  }
}

class RecoveryKeyView extends StatefulWidget {
  const RecoveryKeyView({super.key});

  @override
  State<RecoveryKeyView> createState() => _RecoveryKeyViewState();
}

class _RecoveryKeyViewState extends State<RecoveryKeyView>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await context.read<RecoveryKeyCubit>().getMnemonics();
      },
    );

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    final Tween<double> rotationTween = Tween(begin: 20, end: 0);

    animation = rotationTween.animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);
        }
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<RecoveryKeyCubit, RecoveryKeyState>(
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
      },
      builder: (context, state) {
        return BasePage(
          title: l10n.recoveryKeyTitle,
          titleAlignment: Alignment.topCenter,
          titleLeading: const BackLeadingButton(),
          titleTrailing: AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return Text(
                timeFormatter(timeInSecond: animation.value.toInt()),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              );
            },
          ),
          secureScreen: true,
          scrollView: false,
          body: Column(
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
              if (state.mnemonics != null)
                MnemonicDisplay(mnemonic: state.mnemonics!)
            ],
          ),
          navigation: state.mnemonics != null && !state.hasVerifiedMnemonics
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.spaceSmall,
                      vertical: Sizes.spaceSmall,
                    ),
                    child: MyGradientButton(
                      text: l10n.verifyNow,
                      verticalSpacing: 18,
                      onPressed: () async {
                        animationController.stop();
                        await Navigator.of(context).push(
                          OnBoardingVerifyPhrasePage.route(
                            mnemonic: state.mnemonics!,
                            isFromOnboarding: false,
                          ),
                        );
                        await context.read<RecoveryKeyCubit>().getMnemonics();
                        await animationController.forward();
                      },
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
