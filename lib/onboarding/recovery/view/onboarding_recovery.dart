import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
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
      child: BlocConsumer<OnBoardingRecoveryCubit, OnBoardingRecoveryState>(
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
            title: l10n.import_wallet,
            titleLeading: const BackLeadingButton(),
            scrollView: false,
            useSafeArea: true,
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            body: BackgroundCard(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: Sizes.spaceLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.spaceLarge,
                      ),
                      child: Text(
                        l10n.importWalletText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              letterSpacing: 1.2,
                            ),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceLarge),
                    BaseTextField(
                      height: Sizes.recoveryPhraseTextFieldHeight,
                      hint: l10n.importWalletHintText,
                      fillColor: Colors.transparent,
                      hintStyle: Theme.of(context).textTheme.hintTextFieldStyle,
                      maxLines: 10,
                      borderRadius: Sizes.normalRadius,
                      controller: mnemonicController,
                      error: state.isTextFieldEdited && !state.isMnemonicValid
                          ? l10n.recoveryMnemonicError
                          : null,
                    ),
                    const SizedBox(height: Sizes.spaceSmall),
                    Text(
                      l10n.recoveryPhraseDescriptions,
                      style: Theme.of(context).textTheme.infoSubtitle.copyWith(
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: Sizes.space2XLarge),
                    Text(
                      l10n.importEasilyFrom,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: Sizes.spaceSmall),
                    WalletTypeList(
                      onItemTap: (wallet) {
                        // TODO(all): switch on wallet type on navigate to true screen
                      },
                    ),
                    const SizedBox(height: Sizes.spaceNormal),
                  ],
                ),
              ),
            ),
            navigation: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.spaceSmall),
                child: MyGradientButton(
                  text: l10n.import,
                  onPressed: !state.isMnemonicValid
                      ? null
                      : () async {
                          await context
                              .read<OnBoardingRecoveryCubit>()
                              .saveMnemonic(mnemonicController.text);
                        },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
