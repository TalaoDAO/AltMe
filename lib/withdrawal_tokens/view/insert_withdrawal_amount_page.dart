import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
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
        child: SingleChildScrollView(
          child: Padding(
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
                  height: Sizes.spaceXLarge,
                ),
              ],
            ),
          ),
        ),
      ),
      navigation: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: MyElevatedButton(
            borderRadius: Sizes.normalRadius,
            text: l10n.next,
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
