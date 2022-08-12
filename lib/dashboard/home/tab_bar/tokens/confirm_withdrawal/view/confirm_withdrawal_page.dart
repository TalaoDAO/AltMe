import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmWithdrawalPage extends StatelessWidget {
  const ConfirmWithdrawalPage({
    Key? key,
    required this.selectedToken,
    required this.withdrawalAddress,
    required this.selectedAccountSecretKey,
    required this.amount,
  }) : super(key: key);

  static Route route({
    required TokenModel selectedToken,
    required String withdrawalAddress,
    required String selectedAccountSecretKey,
    required double amount,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ConfirmWithdrawalView'),
      builder: (_) => BlocProvider<ConfirmWithdrawalCubit>(
        create: (_) => ConfirmWithdrawalCubit(
          initialState: ConfirmWithdrawalState(
            withdrawalAddress: withdrawalAddress,
            networkFee: NetworkFeeModel.networks()[1],
          ),
        ),
        child: ConfirmWithdrawalPage(
          selectedToken: selectedToken,
          withdrawalAddress: withdrawalAddress,
          selectedAccountSecretKey: selectedAccountSecretKey,
          amount: amount,
        ),
      ),
    );
  }

  final TokenModel selectedToken;
  final String withdrawalAddress;
  final String selectedAccountSecretKey;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConfirmWithdrawalCubit>(
      create: (_) => ConfirmWithdrawalCubit(
        initialState: ConfirmWithdrawalState(
          withdrawalAddress: withdrawalAddress,
          networkFee: NetworkFeeModel.networks()[1],
        ),
      ),
      child: ConfirmWithdrawalView(
        selectedToken: selectedToken,
        withdrawalAddress: withdrawalAddress,
        selectedAccountSecretKey: selectedAccountSecretKey,
        amount: amount,
      ),
    );
  }
}

class ConfirmWithdrawalView extends StatefulWidget {
  const ConfirmWithdrawalView({
    Key? key,
    required this.selectedToken,
    required this.withdrawalAddress,
    required this.selectedAccountSecretKey,
    required this.amount,
  }) : super(key: key);

  static Route route({
    required TokenModel selectedToken,
    required String withdrawalAddress,
    required String selectedAccountSecretKey,
    required double amount,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ConfirmWithdrawalView'),
      builder: (_) => BlocProvider<ConfirmWithdrawalCubit>(
        create: (_) => ConfirmWithdrawalCubit(
          initialState: ConfirmWithdrawalState(
            withdrawalAddress: withdrawalAddress,
            networkFee: NetworkFeeModel.networks()[1],
          ),
        ),
        child: ConfirmWithdrawalView(
          selectedToken: selectedToken,
          withdrawalAddress: withdrawalAddress,
          selectedAccountSecretKey: selectedAccountSecretKey,
          amount: amount,
        ),
      ),
    );
  }

  final TokenModel selectedToken;
  final String withdrawalAddress;
  final String selectedAccountSecretKey;
  final double amount;

  @override
  State<ConfirmWithdrawalView> createState() => _ConfirmWithdrawalViewState();
}

class _ConfirmWithdrawalViewState extends State<ConfirmWithdrawalView> {
  late final TextEditingController withdrawalAddressController =
      TextEditingController(text: widget.withdrawalAddress);

  late final amountAndSymbol =
      '''${widget.amount.toStringAsFixed(6).formatNumber()} ${widget.selectedToken.symbol}''';

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
    return BlocConsumer<ConfirmWithdrawalCubit, ConfirmWithdrawalState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.message != null) {
          AlertMessage.showStringMessage(
            context: context,
            message: l10n.withdrawalFailedMessage,
            messageType: MessageType.error,
          );
          // TODO(Taleb): update to this later
          // AlertMessage.showStateMessage(
          //   context: context,
          //   stateMessage: state.message!,
          // );
        }
        if (state.status == AppStatus.success) {
          TransactionDoneDialog.show(
            context: context,
            amountAndSymbol: amountAndSymbol,
            onDoneButtonClick: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }
      },
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
                  const AccountSelectBoxView(isEnabled: false),
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
                    amount: widget.amount,
                    symbol: widget.selectedToken.symbol,
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
                        .canConfirmTheWithdrawal(
                          amount: widget.amount,
                          selectedToken: widget.selectedToken,
                        )
                    ? () {
                        ///send to this account for test :
                        ///tz1Z5ad29RQnbn6bcN8E9YTz3djnqhTSgStf
                        ///this is EmptyAcc1
                        Navigator.of(context).push<void>(
                          PinCodePage.route(
                            restrictToBack: false,
                            isValidCallback: () {
                              context
                                  .read<ConfirmWithdrawalCubit>()
                                  .withdrawTezos(
                                    tokenAmount: widget.amount,
                                    selectedAccountSecretKey:
                                        widget.selectedAccountSecretKey,
                                  );
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
