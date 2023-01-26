import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class ImportAccountStep3Page extends StatelessWidget {
  const ImportAccountStep3Page({super.key, required this.accountType});
  final AccountType accountType;

  static Route<dynamic> route({required AccountType accountType}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/importAccountStep3Page'),
      builder: (_) => ImportAccountStep3Page(
        accountType: accountType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImportAccountCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
      ),
      child: ImportAccountStep3View(
        accountType: accountType,
      ),
    );
  }
}

class ImportAccountStep3View extends StatefulWidget {
  const ImportAccountStep3View({super.key, required this.accountType});
  final AccountType accountType;

  @override
  State<ImportAccountStep3View> createState() => _ImportAccountStep3ViewState();
}

class _ImportAccountStep3ViewState extends State<ImportAccountStep3View> {
  late TextEditingController mnemonicController;

  @override
  void initState() {
    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<ImportAccountCubit>()
          .isMnemonicsOrKeyValid(mnemonicController.text);
    });
    context.read<ImportAccountCubit>().setAccountType(widget.accountType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.importAccount,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MStepper(
            totalStep: 4,
            step: 3,
          ),
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
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
          BlocBuilder<ImportAccountCubit, ImportAccountState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.bottomRight,
                fit: StackFit.loose,
                children: [
                  BaseTextField(
                    height: Sizes.recoveryPhraseTextFieldHeight,
                    hint: l10n.importWalletHintText(
                      state.accountType == AccountType.tezos ? 54 : 64,
                    ),
                    fillColor: Colors.transparent,
                    hintStyle: Theme.of(context).textTheme.hintTextFieldStyle,
                    maxLines: 10,
                    borderRadius: Sizes.normalRadius,
                    controller: mnemonicController,
                    error:
                        state.isTextFieldEdited && !state.isMnemonicOrKeyValid
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
                        color: Theme.of(context).colorScheme.checkMarkColor,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: Sizes.icon,
                        color: Colors.white,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: Sizes.spaceSmall),
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
        ],
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: BlocBuilder<ImportAccountCubit, ImportAccountState>(
          builder: (context, state) {
            return MyElevatedButton(
              text: l10n.next,
              onPressed: !state.isMnemonicOrKeyValid
                  ? null
                  : () async {
                      LoadingView().show(context: context);
                      await getSecureStorage.delete(
                        SecureStorageKeys.importAccountStep2Mnemonics,
                      );
                      await getSecureStorage.set(
                        SecureStorageKeys.importAccountStep2Mnemonics,
                        mnemonicController.text,
                      );
                      LoadingView().hide();
                      await Navigator.of(context).push<void>(
                        ImportAccountStep4Page.route(
                          importAccountCubit:
                              context.read<ImportAccountCubit>(),
                        ),
                      );
                    },
            );
          },
        ),
      ),
    );
  }
}
