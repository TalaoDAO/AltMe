import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/models/token_model.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:flutter/material.dart';

class InsertWithdrawalAmountPage extends StatefulWidget {
  const InsertWithdrawalAmountPage({
    Key? key,
    required this.withdrawalAddress,
    required this.accountData,
  }) : super(key: key);

  final String withdrawalAddress;
  final CryptoAccountData accountData;

  static Route route({
    required String withdrawalAddress,
    required CryptoAccountData accountData,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => InsertWithdrawalAmountPage(
        withdrawalAddress: withdrawalAddress,
        accountData: accountData,
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
    'contractAddress',
    'Tezos',
    'XTZ',
    'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
    null,
    '12345667',
    '6',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      titleTrailing: const AccountSwitcherButton(),
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
            TokenSelectBoxView(initialToken: tempModel),
            TokenAmountCalculatorView(
              tokenSymbol: 'XTZ',
              tokenModel: tempModel,
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
          child: MyElevatedButton(
            borderRadius: Sizes.normalRadius,
            text: l10n.next,
            onPressed: () {
              Navigator.of(context).push<void>(ConfirmWithdrawalPage.route());
            },
          ),
        ),
      ),
    );
  }
}
