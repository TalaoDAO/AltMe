import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmWithdrawalPage extends StatefulWidget {
  const ConfirmWithdrawalPage({
    Key? key,
    required this.selectedToken,
    required this.withdrawalAddress,
    required this.amount,
  }) : super(key: key);

  static Route route({
    required TokenModel selectedToken,
    required String withdrawalAddress,
    required String selectedAccountSecretKey,
    required double amount,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<ConfirmWithdrawalCubit>(
        create: (_) => ConfirmWithdrawalCubit(
          selectedAccountSecretKey: selectedAccountSecretKey,
          initialState: ConfirmWithdrawalState(
            withdrawalAddress: withdrawalAddress,
            selectedToken: selectedToken,
            amount: amount,
            networkFee: NetworkFeeModel.networks()[1],
          ),
        ),
        child: ConfirmWithdrawalPage(
          selectedToken: selectedToken,
          withdrawalAddress: withdrawalAddress,
          amount: amount,
        ),
      ),
    );
  }

  final TokenModel selectedToken;
  final String withdrawalAddress;
  final double amount;

  @override
  State<ConfirmWithdrawalPage> createState() => _ConfirmWithdrawalPageState();
}

class _ConfirmWithdrawalPageState extends State<ConfirmWithdrawalPage> {
  late final TextEditingController withdrawalAddressController =
      TextEditingController(text: widget.withdrawalAddress);

  final AccountSelectBoxController accountSelectBoxController =
      AccountSelectBoxController();

  late final amountAndSymbol =
      '${widget.amount.toStringAsFixed(6).formatNumber()} ${widget.selectedToken.symbol}';

  @override
  void initState() {
    withdrawalAddressController.addListener(() {
      context.read<ConfirmWithdrawalCubit>().setWithdrawalAddress(
            withdrawalAddress: withdrawalAddressController.text,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ConfirmWithdrawalCubit, ConfirmWithdrawalState>(
      builder: (context, state) {
        return BasePage(
          scrollView: false,
          title: l10n.confirm,
          titleLeading: const BackLeadingButton(),
          body: BackgroundCard(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: Sizes.spaceSmall,
                  ),
                  Text(
                    l10n.amount,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: Sizes.spaceSmall,
                  ),
                  MyText(
                    amountAndSymbol,
                    textAlign: TextAlign.center,
                    minFontSize: 12,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(
                    height: Sizes.spaceSmall,
                  ),
                  AccountSelectBoxView(
                    controller: accountSelectBoxController,
                    caption: l10n.from,
                    isEnabled: false,
                  ),
                  const SizedBox(
                    height: Sizes.spaceNormal,
                  ),
                  WithdrawalAddressInputView(
                    withdrawalAddressController: withdrawalAddressController,
                    caption: l10n.to,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Sizes.spaceSmall),
                    child: Image.asset(
                      IconStrings.arrowDown,
                      height: Sizes.icon3x,
                    ),
                  ),
                  ConfirmDetailsCard(
                    amount: state.amount,
                    symbol: state.selectedToken.symbol,
                    networkFee: state.networkFee,
                    onEditButtonPressed: () {
                      SelectNetworkFeeBottomSheet.show(
                        context: context,
                        selectedNetwork: state.networkFee,
                        onChange: (networkFee) {
                          context
                              .read<ConfirmWithdrawalCubit>()
                              .setNetworkFee(networkFee: networkFee);
                        },
                      );
                    },
                  ),
                ],
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
              child: MyElevatedButton(
                borderRadius: Sizes.normalRadius,
                text: l10n.confirm,
                onPressed: context
                        .read<ConfirmWithdrawalCubit>()
                        .canConfirmTheWithdrawal()
                    ? () {
                        ///send to this account for test : tz1Z5ad29RQnbn6bcN8E9YTz3djnqhTSgStf
                        ///this is EmptyAcc1
                        context.read<ConfirmWithdrawalCubit>().withdrawTezos();
                        Navigator.of(context).push<void>(
                          PinCodePage.route(
                            restrictToBack: false,
                            isValidCallback: () async {
                              LoadingView().show(context: context);
                              final isSuccess = await context
                                  .read<ConfirmWithdrawalCubit>()
                                  .withdrawTezos();
                              LoadingView().hide();
                              if (isSuccess) {
                                //show success alert and pop to home when user press OK
                                await TransactionDoneDialog.show(
                                  context: context,
                                  amountAndSymbol: amountAndSymbol,
                                  onDoneButtonClick: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                );
                              } else {
                                //show alert
                              }
                            },
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
