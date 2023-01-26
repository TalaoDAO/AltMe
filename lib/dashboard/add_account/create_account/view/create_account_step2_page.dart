import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/widgets/m_stepper.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';

class CreateAccountStep2Page extends StatelessWidget {
  const CreateAccountStep2Page({
    super.key,
    required this.accountType,
  });

  final AccountType accountType;

  static Route<dynamic> route({required AccountType accountType}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/createAccountStep2Page'),
      builder: (_) => CreateAccountStep2Page(accountType: accountType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateAccountCubit(
        walletCubit: context.read<WalletCubit>(),
      ),
      child: CreateAccountStep2View(
        accountType: accountType,
      ),
    );
  }
}

class CreateAccountStep2View extends StatefulWidget {
  const CreateAccountStep2View({
    super.key,
    required this.accountType,
  });

  final AccountType accountType;

  @override
  State<CreateAccountStep2View> createState() => _CreateAccountStep2ViewState();
}

class _CreateAccountStep2ViewState extends State<CreateAccountStep2View> {
  late final TextEditingController accountNameTextController;
  late final List<String> accountNameList;

  @override
  void initState() {
    final List<CryptoAccountData> cryptoAccount =
        context.read<WalletCubit>().state.cryptoAccount.data;
    accountNameList = cryptoAccount.map((e) => e.name).toList();
    accountNameTextController = TextEditingController(
      text: generateDefaultAccountName(
        accountNameList.length,
        accountNameList,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<CreateAccountCubit, CreateAccountState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.status == AppStatus.success) {
          Navigator.of(context).pushReplacement<void, void>(
            CongratulationsAccountCreationPage.route(
              accountType: widget.accountType,
            ),
          );
        }

        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }
      },
      child: BasePage(
        title: l10n.createAccount,
        titleAlignment: Alignment.topCenter,
        padding: const EdgeInsets.only(
          top: 0,
          left: Sizes.spaceSmall,
          right: Sizes.spaceSmall,
          bottom: Sizes.spaceSmall,
        ),
        titleLeading: const BackLeadingButton(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MStepper(
              totalStep: 2,
              step: 2,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            Text(
              l10n.setAccountNameDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall3,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            BaseTextField(
              controller: accountNameTextController,
              borderRadius: Sizes.smallRadius,
              textCapitalization: TextCapitalization.sentences,
              fillColor: Theme.of(context).highlightColor,
              contentPadding: const EdgeInsets.symmetric(
                vertical: Sizes.spaceSmall,
                horizontal: Sizes.spaceSmall,
              ),
              borderColor: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ],
        ),
        navigation: Padding(
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: MyElevatedButton(
            text: l10n.next,
            onPressed: () {
              final accountName = accountNameTextController.text;
              if (accountName.trim().isEmpty ||
                  accountNameList.contains(accountName)) {
                return AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: StateMessage.error(
                    stringMessage: l10n.sameAccountNameError,
                  ),
                );
              } else {
                context.read<CreateAccountCubit>().createCryptoAccount(
                      accountName: accountName,
                      blockChaintype: getBlockchainType(widget.accountType),
                    );
              }
            },
          ),
        ),
      ),
    );
  }
}
