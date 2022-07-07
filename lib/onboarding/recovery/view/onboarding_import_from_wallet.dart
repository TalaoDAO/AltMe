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

class OnBoardingImportFromWalletPage extends StatelessWidget {
  const OnBoardingImportFromWalletPage({
    Key? key,
    required this.walletTypeModel,
  }) : super(key: key);

  static Route route({required WalletTypeModel walletTypeModel}) =>
      MaterialPageRoute<void>(
        builder: (context) => OnBoardingImportFromWalletPage(
          walletTypeModel: walletTypeModel,
        ),
        settings: const RouteSettings(name: '/onBoardingImportFromWalletPage'),
      );

  final WalletTypeModel walletTypeModel;

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
      child: OnBoardingImportFromWalletView(
        walletTypeModel: walletTypeModel,
      ),
    );
  }
}

class OnBoardingImportFromWalletView extends StatefulWidget {
  const OnBoardingImportFromWalletView({
    Key? key,
    required this.walletTypeModel,
  }) : super(key: key);

  final WalletTypeModel walletTypeModel;

  @override
  _OnBoardingImportFromWalletViewState createState() =>
      _OnBoardingImportFromWalletViewState();
}

class _OnBoardingImportFromWalletViewState
    extends State<OnBoardingImportFromWalletView> {
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
        } else {
          await Navigator.of(context)
              .pushReplacement<void, void>(OnBoardingRecoveryPage.route());
          return false;
        }
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
            title: '${l10n.import} ${widget.walletTypeModel.walletName}',
            titleLeading: BackLeadingButton(
              onPressed: () {
                Navigator.of(context).pushReplacement<void, void>(
                    OnBoardingRecoveryPage.route());
              },
            ),
            scrollView: false,
            useSafeArea: true,
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            body: BackgroundCard(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: Sizes.spaceNormal),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(Sizes.spaceXSmall),
                      width: Sizes.icon4x,
                      height: Sizes.icon4x,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Sizes.smallRadius),
                        ),
                      ),
                      child: Image.asset(
                        widget.walletTypeModel.imagePath,
                        width: Sizes.icon3x,
                        height: Sizes.icon3x,
                      ),
                    ),
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
