import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/recovery/cubit/onboarding_recovery_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingRecoveryPage extends StatelessWidget {
  const OnBoardingRecoveryPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingRecoveryPage(),
        settings: const RouteSettings(name: '/onBoardingRecoveryPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingRecoveryCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
      ),
      child: const OnBoardingRecoveryView(),
    );
  }
}

class OnBoardingRecoveryView extends StatefulWidget {
  const OnBoardingRecoveryView({Key? key}) : super(key: key);

  @override
  _OnBoardingRecoveryViewState createState() => _OnBoardingRecoveryViewState();
}

class _OnBoardingRecoveryViewState extends State<OnBoardingRecoveryView> {
  late TextEditingController mnemonicController;

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.recoveryText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BaseTextField(
                    label: l10n.recoveryMnemonicHintText,
                    controller: mnemonicController,
                    error: state.isTextFieldEdited && !state.isMnemonicValid
                        ? l10n.recoveryMnemonicError
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: BaseButton.primary(
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
