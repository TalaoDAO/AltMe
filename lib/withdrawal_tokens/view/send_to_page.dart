import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendToPage extends StatefulWidget {
  const SendToPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const SendToPage(),
      settings: const RouteSettings(name: '/sendToPage'),
    );
  }

  @override
  State<SendToPage> createState() => _SendToPageState();
}

class _SendToPageState extends State<SendToPage> {
  final TextEditingController withdrawalAddressController =
      TextEditingController();

  final AccountSelectBoxController accountSelectBoxController =
      AccountSelectBoxController();

  late final SendToCubit sendToCubit = SendToCubit(
    selectedAccount: context
        .read<WalletCubit>()
        .state
        .cryptoAccount
        .data[context.read<WalletCubit>().state.currentCryptoIndex],
  );

  @override
  void initState() {
    withdrawalAddressController.addListener(() {
      sendToCubit.setWithdrawalAddress(
        withdrawalAddress: withdrawalAddressController.text,
      );
    });

    accountSelectBoxController.stream.listen((selectedAccount) {
      sendToCubit.setSelectedAccount(
        selectedAccount: selectedAccount!,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    accountSelectBoxController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider<SendToCubit>(
      create: (_) => sendToCubit,
      child: BasePage(
        scrollView: false,
        titleLeading: const BackLeadingButton(),
        titleTrailing: const AccountSwitcherButton(),
        body: BackgroundCard(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    l10n.sendTo,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: Sizes.spaceXLarge,
                  ),
                  AccountSelectBoxView(
                    controller: accountSelectBoxController,
                    caption: l10n.from,
                  ),
                  const SizedBox(
                    height: Sizes.spaceNormal,
                  ),
                  WithdrawalAddressInputView(
                    withdrawalAddressController: withdrawalAddressController,
                    caption: l10n.to,
                  ),
                ],
              ),
            ),
          ),
        ),
        navigation: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.spaceSmall,
              right: Sizes.spaceSmall,
              bottom: Sizes.spaceSmall,
            ),
            child: BlocBuilder<SendToCubit, SendToState>(
              builder: (context, state) {
                return MyElevatedButton(
                  borderRadius: Sizes.normalRadius,
                  text: l10n.next,
                  onPressed: state.withdrawalAddress.trim().isEmpty
                      ? null
                      : () {
                          Navigator.of(context).push<void>(
                            InsertWithdrawalAmountPage.route(
                              withdrawalAddress: state.withdrawalAddress,
                            ),
                          );
                        },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
