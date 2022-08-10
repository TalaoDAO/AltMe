import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsertWithdrawalAmountPage extends StatefulWidget {
  const InsertWithdrawalAmountPage({
    Key? key,
    required this.withdrawalAddress,
  }) : super(key: key);

  final String withdrawalAddress;

  static Route route({
    required String withdrawalAddress,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<InsertWithdrawalPageCubit>(
        create: (_) => InsertWithdrawalPageCubit(),
        child: InsertWithdrawalAmountPage(
          withdrawalAddress: withdrawalAddress,
        ),
      ),
    );
  }

  @override
  State<InsertWithdrawalAmountPage> createState() =>
      _InsertWithdrawalAmountPageState();
}

class _InsertWithdrawalAmountPageState
    extends State<InsertWithdrawalAmountPage> {
  final TextEditingController withdrawalAddressController =
      TextEditingController();

  final tempModel = const TokenModel(
    '',
    'Tezos',
    'XTZ',
    'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
    null,
    '00000000',
    '6',
  );

  late final TokenSelectBoxController _tokenSelectBoxController =
      TokenSelectBoxController(selectedToken: tempModel);

  final TokenAmountCalculatorController _tokenAmountCalculatorController =
      TokenAmountCalculatorController();

  @override
  void initState() {
    _tokenAmountCalculatorController.stream.listen((calculatorAmount) {
      context.read<InsertWithdrawalPageCubit>().isValidWithdrawal(
            isValid: calculatorAmount > 0.0,
          );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      titleTrailing: const CryptoAccountSwitcherButton(),
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              l10n.amount,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            TokenSelectBoxView(
              controller: _tokenSelectBoxController,
            ),
            TokenAmountCalculatorView(
              controller: _tokenAmountCalculatorController,
              tokenSelectBoxController: _tokenSelectBoxController,
            ),
          ],
        ),
      ),
      navigation: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.spaceSmall,
            right: Sizes.spaceSmall,
            bottom: Sizes.spaceSmall,
          ),
          child: BlocBuilder<WalletCubit, WalletState>(
            builder: (context, walletState) {
              _tokenSelectBoxController.setSelectedAccount(
                selectedToken: tempModel,
              );
              return BlocBuilder<InsertWithdrawalPageCubit, bool>(
                builder: (context, isValidWithdrawal) {
                  return MyElevatedButton(
                    borderRadius: Sizes.normalRadius,
                    text: l10n.next,
                    onPressed: isValidWithdrawal
                        ? () {
                            Navigator.of(context).push<void>(
                              ConfirmWithdrawalPage.route(
                                selectedToken: _tokenSelectBoxController.state,
                                withdrawalAddress: widget.withdrawalAddress,
                                amount: _tokenAmountCalculatorController.state,
                                selectedAccountSecretKey: walletState
                                    .cryptoAccount
                                    .data[walletState.currentCryptoIndex]
                                    .secretKey,
                              ),
                            );
                          }
                        : null,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
