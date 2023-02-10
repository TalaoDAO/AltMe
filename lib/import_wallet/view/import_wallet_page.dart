import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/import_wallet/import_wallet.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class ImportWalletPage extends StatelessWidget {
  const ImportWalletPage({
    super.key,
    this.accountName,
    required this.isFromOnboarding,
  });

  static Route<dynamic> route({
    String? accountName,
    required bool isFromOnboarding,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => ImportWalletPage(
          accountName: accountName,
          isFromOnboarding: isFromOnboarding,
        ),
        settings: const RouteSettings(name: '/onBoardingRecoveryPage'),
      );

  final String? accountName;
  final bool isFromOnboarding;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImportWalletCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
      ),
      child: ImportWalletView(
        accountName: accountName,
        isFromOnboarding: isFromOnboarding,
      ),
    );
  }
}

class ImportWalletView extends StatefulWidget {
  const ImportWalletView({
    super.key,
    this.accountName,
    required this.isFromOnboarding,
  });

  final String? accountName;
  final bool isFromOnboarding;

  @override
  _ImportWalletViewState createState() => _ImportWalletViewState();
}

class _ImportWalletViewState extends State<ImportWalletView> {
  late TextEditingController mnemonicController;

  @override
  void initState() {
    super.initState();

    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<ImportWalletCubit>()
          .isMnemonicsOrKeyValid(mnemonicController.text);
    });
  }

  @override
  void dispose() {
    mnemonicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ImportWalletCubit, ImportWalletState>(
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
          if (widget.isFromOnboarding) {
            context.read<LiveChatCubit>().init();
            Navigator.pushAndRemoveUntil<void>(
              context,
              WalletReadyPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          } else {
            Navigator.pushAndRemoveUntil<void>(
              context,
              DashboardPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          }
        }
      },
      builder: (context, state) {
        return BasePage(
          title: l10n.importAccount,
          titleLeading: const BackLeadingButton(),
          scrollView: true,
          useSafeArea: true,
          titleAlignment: Alignment.topCenter,
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          body: BackgroundCard(
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.isFromOnboarding)
                  const MStepper(
                    step: 3,
                    totalStep: 3,
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
                if (widget.isFromOnboarding)
                  Column(
                    children: [
                      const SizedBox(height: Sizes.spaceLarge),
                      Stack(
                        alignment: Alignment.bottomRight,
                        fit: StackFit.loose,
                        children: [
                          BaseTextField(
                            height: Sizes.recoveryPhraseTextFieldHeight,
                            hint: l10n.importWalletHintText(54),
                            fillColor: Colors.transparent,
                            hintStyle:
                                Theme.of(context).textTheme.hintTextFieldStyle,
                            maxLines: 10,
                            borderRadius: Sizes.normalRadius,
                            controller: mnemonicController,
                            error: state.isTextFieldEdited &&
                                    !state.isMnemonicOrKeyValid
                                ? l10n.recoveryMnemonicError
                                : null,
                          ),
                          if (state.isMnemonicOrKeyValid)
                            Container(
                              alignment: Alignment.center,
                              width: Sizes.icon2x,
                              height: Sizes.icon2x,
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.all(Sizes.spaceNormal),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .checkMarkColor,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: Sizes.icon,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ],
                  )
                else
                  const SizedBox(height: Sizes.space2XLarge),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                Text(
                  l10n.importEasilyFrom,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: Sizes.spaceSmall),
                WalletTypeList(
                  onItemTap: (wallet) {
                    Navigator.of(context).push<void>(
                      ImportFromWalletPage.route(
                        walletTypeModel: wallet,
                        accountName: widget.accountName,
                        isFromOnboard: widget.isFromOnboarding,
                      ),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceLarge),
                Text(
                  l10n.recoveryPhraseDescriptions,
                  style: Theme.of(context).textTheme.infoSubtitle.copyWith(
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: Sizes.spaceLarge),
                Text(
                  l10n.privateKeyDescriptions,
                  style: Theme.of(context).textTheme.infoSubtitle.copyWith(
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: Sizes.spaceNormal),
              ],
            ),
          ),
          navigation: widget.isFromOnboarding
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.spaceSmall),
                    child: MyGradientButton(
                      text: l10n.import,
                      onPressed: !state.isMnemonicOrKeyValid
                          ? null
                          : () async {
                              await context.read<ImportWalletCubit>().import(
                                    mnemonicOrKey: mnemonicController.text,
                                    accountName: widget.accountName,
                                    isFromOnboarding: widget.isFromOnboarding,
                                  );
                            },
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
