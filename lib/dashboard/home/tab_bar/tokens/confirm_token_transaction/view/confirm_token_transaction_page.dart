import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmTokenTransactionPage extends StatelessWidget {
  const ConfirmTokenTransactionPage({
    Key? key,
    required this.selectedToken,
    required this.withdrawalAddress,
    required this.amount,
    this.isNFT = false,
  }) : super(key: key);

  static Route route({
    required TokenModel selectedToken,
    required String withdrawalAddress,
    required double amount,
    bool isNFT = false,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ConfirmTokenTransactionPage'),
      builder: (_) => ConfirmTokenTransactionPage(
        selectedToken: selectedToken,
        withdrawalAddress: withdrawalAddress,
        amount: amount,
        isNFT: isNFT,
      ),
    );
  }

  final TokenModel selectedToken;
  final String withdrawalAddress;
  final double amount;
  final bool isNFT;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConfirmTokenTransactionCubit>(
      create: (_) => ConfirmTokenTransactionCubit(
        manageNetworkCubit: context.read<ManageNetworkCubit>(),
        client: DioClient('', Dio()),
        initialState: ConfirmTokenTransactionState(
          withdrawalAddress: withdrawalAddress,
          tokenAmount: amount,
          totalAmount: amount,
          selectedToken: selectedToken,
          selectedAccountSecretKey:
              context.read<WalletCubit>().state.currentAccount!.secretKey,
        ),
      ),
      child: ConfirmWithdrawalView(
        selectedToken: selectedToken,
        withdrawalAddress: withdrawalAddress,
        amount: amount,
        isNFT: isNFT,
      ),
    );
  }
}

class ConfirmWithdrawalView extends StatefulWidget {
  const ConfirmWithdrawalView({
    Key? key,
    required this.selectedToken,
    required this.withdrawalAddress,
    required this.amount,
    this.isNFT = false,
  }) : super(key: key);

  final TokenModel selectedToken;
  final String withdrawalAddress;
  final double amount;
  final bool isNFT;

  @override
  State<ConfirmWithdrawalView> createState() => _ConfirmWithdrawalViewState();
}

class _ConfirmWithdrawalViewState extends State<ConfirmWithdrawalView> {
  late final TextEditingController withdrawalAddressController =
      TextEditingController(text: widget.withdrawalAddress);

  @override
  void initState() {
    withdrawalAddressController.addListener(() {
      context.read<ConfirmTokenTransactionCubit>().setWithdrawalAddress(
            withdrawalAddress: withdrawalAddressController.text,
          );
    });
    Future.microtask(context.read<ConfirmTokenTransactionCubit>().calculateFee);
    super.initState();
  }

  int getDecimalsToShow(double amount) {
    return widget.selectedToken.decimalsToShow == 0
        ? 0
        : amount >= 1
            ? 2
            : 5;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ConfirmTokenTransactionCubit,
        ConfirmTokenTransactionState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.message != null &&
            (state.status == AppStatus.error ||
                state.status == AppStatus.errorWhileFetching)) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }
        if (state.status == AppStatus.success) {
          final amountAndSymbol =
              '''${widget.isNFT ? widget.amount.toInt() : state.totalAmount.toStringAsFixed(getDecimalsToShow(state.totalAmount)).formatNumber()} ${widget.isNFT ? '${widget.selectedToken.symbol} #${widget.selectedToken.tokenId}' : widget.selectedToken.symbol}''';
          TransactionDoneDialog.show(
            context: context,
            amountAndSymbol: amountAndSymbol,
            transactionHash: state.transactionHash,
            onTrasactionHashTap: () {
              final network = context.read<ManageNetworkCubit>().state.network;
              if (state.transactionHash != null) {
                openBlockchainExplorer(network, state.transactionHash!);
              }
            },
            onDoneButtonClick: () {
              Navigator.popUntil(
                context,
                (route) => route.settings.name == '/dashboardPage',
              );
            },
          );
        }
      },
      builder: (context, state) {
        final amountAndSymbol =
            '''${widget.isNFT ? widget.amount.toInt() : state.totalAmount.toStringAsFixed(getDecimalsToShow(state.totalAmount)).formatNumber()} ${widget.isNFT ? '${widget.selectedToken.symbol} #${widget.selectedToken.tokenId}' : widget.selectedToken.symbol}''';
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
                  const SizedBox(height: Sizes.spaceSmall),
                  const AccountSelectBoxView(isEnabled: false),
                  const SizedBox(height: Sizes.spaceNormal),
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
                  ConfirmTransactionDetailsCard(
                    amount: state.tokenAmount,
                    symbol: state.selectedToken.symbol,
                    grandTotal: state.totalAmount,
                    tokenUSDRate: widget.selectedToken.tokenUSDPrice,
                    networkFee: state.networkFee,
                    isNFT: widget.isNFT,
                    networkFees: state.networkFees,
                    onEditButtonPressed: () async {
                      final NetworkFeeModel? networkFeeModel =
                          await SelectNetworkFeeBottomSheet.show(
                        context: context,
                        selectedNetworkFee: state.networkFee!,
                        networkFeeList: state.networkFees ?? [],
                      );

                      if (networkFeeModel != null) {
                        context
                            .read<ConfirmTokenTransactionCubit>()
                            .setNetworkFee(networkFee: networkFeeModel);
                      }
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
                        .read<ConfirmTokenTransactionCubit>()
                        .canConfirmTheWithdrawal(
                          amount: widget.amount,
                          selectedToken: widget.selectedToken,
                        )
                    ? () {
                        Navigator.of(context).push<void>(
                          PinCodePage.route(
                            restrictToBack: false,
                            isValidCallback: () {
                              context
                                  .read<ConfirmTokenTransactionCubit>()
                                  .sendContractInvocationOperation();
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
