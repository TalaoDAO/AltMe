import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/gen_phrase/cubit/onboarding_gen_phrase_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingGenPhrasePage extends StatefulWidget {
  const OnBoardingGenPhrasePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) => OnBoardingGenPhraseCubit(
            secureStorageProvider: getSecureStorage,
            didCubit: context.read<DIDCubit>(),
            didKitProvider: DIDKitProvider(),
            keyGenerator: KeyGenerator(),
            homeCubit: context.read<HomeCubit>(),
          ),
          child: const OnBoardingGenPhrasePage(),
        ),
        settings: const RouteSettings(name: '/onBoardingGenPhrasePage'),
      );

  @override
  _OnBoardingGenPhrasePageState createState() =>
      _OnBoardingGenPhrasePageState();
}

class _OnBoardingGenPhrasePageState extends State<OnBoardingGenPhrasePage> {
  OverlayEntry? _overlay;

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
        title: l10n.onBoardingGenPhraseTitle,
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
              _overlay = OverlayEntry(
                builder: (_) => const LoadingDialog(),
              );
              Overlay.of(context)!.insert(_overlay!);
            } else {
              if (_overlay != null) {
                _overlay!.remove();
                _overlay = null;
              }
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
                MnemonicDisplay(mnemonic: state.mnemonic),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          l10n.genPhraseViewLatterText,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 42,
                  child: BaseButton.primary(
                    context: context,
                    onPressed: state.status == AppStatus.loading
                        ? null
                        : () async {
                            await context
                                .read<OnBoardingGenPhraseCubit>()
                                .generateKey(state.mnemonic);
                          },
                    child: Text(l10n.onBoardingGenPhraseButton),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
