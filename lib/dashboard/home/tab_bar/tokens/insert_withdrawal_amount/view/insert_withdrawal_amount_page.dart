import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsertWithdrawalAmountPage extends StatelessWidget {
  const InsertWithdrawalAmountPage({
    super.key,
    required this.withdrawalAddress,
    required this.defaultSelectedToken,
  });

  final String withdrawalAddress;
  final TokenModel defaultSelectedToken;

  static Route<dynamic> route({
    required String withdrawalAddress,
    required TokenModel defualtSelectedToken,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => InsertWithdrawalAmountPage(
        withdrawalAddress: withdrawalAddress,
        defaultSelectedToken: defualtSelectedToken,
      ),
      settings: const RouteSettings(name: '/insertWithdrawalAmountPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InsertWithdrawalPageCubit>(
      create: (_) =>
          InsertWithdrawalPageCubit(defaultSelectedToken: defaultSelectedToken),
      child: InsertWithdrawalAmountView(withdrawalAddress: withdrawalAddress),
    );
  }
}

class InsertWithdrawalAmountView extends StatefulWidget {
  const InsertWithdrawalAmountView({
    super.key,
    required this.withdrawalAddress,
  });

  final String withdrawalAddress;

  @override
  State<InsertWithdrawalAmountView> createState() =>
      _InsertWithdrawalAmountViewState();
}

class _InsertWithdrawalAmountViewState
    extends State<InsertWithdrawalAmountView> {
  late final insertWithdrawalPageCubit =
      context.read<InsertWithdrawalPageCubit>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<InsertWithdrawalPageCubit, InsertWithdrawalPageState>(
      builder: (context, state) {
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
                  height: Sizes.spaceSmall,
                ),
                TokenSelectBoxView(selectedToken: state.selectedToken),
                TokenAmountCalculatorView(selectedToken: state.selectedToken),
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
                onPressed: state.isValidWithdrawal
                    ? () {
                        Navigator.of(context).push<void>(
                          ConfirmTokenTransactionPage.route(
                            selectedToken: state.selectedToken,
                            withdrawalAddress: widget.withdrawalAddress,
                            amount: state.amount,
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
