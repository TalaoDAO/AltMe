import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/recovery/cubit/onboarding_recovery_cubit.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingRecoveryPage extends StatefulWidget {
  const OnBoardingRecoveryPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) => OnBoardingRecoveryCubit(
            cryptoKeys: const CryptocurrencyKeys(),
            secureStorageProvider: getSecureStorage,
            didCubit: context.read<DIDCubit>(),
            didKitProvider: DIDKitProvider(),
            keyGenerator: KeyGenerator(),
            homeCubit: context.read<HomeCubit>(),
          ),
          child: const OnBoardingRecoveryPage(),
        ),
        settings: const RouteSettings(name: '/onBoardingKeyPage'),
      );

  static const _padding = EdgeInsets.symmetric(
    horizontal: 16,
  );

  static Widget _padHorizontal(Widget child) => Padding(
        padding: _padding,
        child: child,
      );

  @override
  _OnBoardingRecoveryPageState createState() => _OnBoardingRecoveryPageState();
}

class _OnBoardingRecoveryPageState extends State<OnBoardingRecoveryPage> {
  late TextEditingController mnemonicController;

  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();

    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<OnBoardingRecoveryCubit>()
          .isMnemonicsValid(mnemonicController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async {
        if (context.read<OnBoardingRecoveryCubit>().state.status ==
            AppStatus.loading) {
          return false;
        }
        return true;
      },
      child: BasePage(
        title: l10n.onBoardingRecoveryTitle,
        titleLeading: const BackLeadingButton(),
        scrollView: false,
        padding: EdgeInsets.zero,
        body: BlocConsumer<OnBoardingRecoveryCubit, OnBoardingRecoveryState>(
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                OnBoardingRecoveryPage._padHorizontal(
                  Text(
                    l10n.recoveryText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                const SizedBox(height: 24),
                BaseTextField(
                  label: l10n.recoveryMnemonicHintText,
                  controller: mnemonicController,
                  error: state.isTextFieldEdited && !state.isMnemonicValid
                      ? l10n.recoveryMnemonicError
                      : null,
                ),
                const SizedBox(height: 24),
                OnBoardingRecoveryPage._padHorizontal(
                  BaseButton.primary(
                    context: context,
                    onPressed: !state.isMnemonicValid
                        ? null
                        : () async {
                            await context
                                .read<OnBoardingRecoveryCubit>()
                                .saveMnemonic(mnemonicController.text);
                          },
                    child: Text(l10n.onBoardingRecoveryButton),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
