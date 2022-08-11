import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsertWithdrawalAmountPage extends StatelessWidget {
  const InsertWithdrawalAmountPage({
    Key? key,
    required this.withdrawalAddress,
  }) : super(key: key);

  final String withdrawalAddress;

  static Route route({required String withdrawalAddress}) {
    return MaterialPageRoute<void>(
      builder: (_) =>
          InsertWithdrawalAmountPage(withdrawalAddress: withdrawalAddress),
      settings: const RouteSettings(name: '/insertWithdrawalAmountPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InsertWithdrawalPageCubit>(
          create: (_) => InsertWithdrawalPageCubit(
            initialState: InsertWithdrawalPageState(
              withdrawalAddress: withdrawalAddress,
              selectedToken: const TokenModel(
                '',
                'Tezos',
                'XTZ',
                'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
                null,
                '00000000',
                '6',
              ),
            ),
          ),
        ),
        BlocProvider<TokensCubit>(
          create: (context) => TokensCubit(
            client: DioClient(
              context.read<ManageNetworkCubit>().state.network.tzktUrl,
              Dio(),
            ),
            walletCubit: context.read<WalletCubit>(),
          ),
        )
      ],
      child: InsertWithdrawalAmountView(withdrawalAddress: withdrawalAddress),
    );
  }
}

class InsertWithdrawalAmountView extends StatefulWidget {
  const InsertWithdrawalAmountView({
    Key? key,
    required this.withdrawalAddress,
  }) : super(key: key);

  final String withdrawalAddress;

  @override
  State<InsertWithdrawalAmountView> createState() =>
      _InsertWithdrawalAmountViewState();
}

class _InsertWithdrawalAmountViewState
    extends State<InsertWithdrawalAmountView> {
  late final insertWithdrawalPageCubit =
      context.read<InsertWithdrawalPageCubit>();

  late final tokenAmountCalculatorCubit = TokenAmountCalculatorCubit(
    selectedToken: insertWithdrawalPageCubit.state.selectedToken,
    onAmountChanged: (double amount) {
      insertWithdrawalPageCubit.setAmount(amount: amount);
    },
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<InsertWithdrawalPageCubit, InsertWithdrawalPageState>(
      builder: (context, state) {
        getLogger(toStringShort()).i('state: $state');
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
                  selectedToken: state.selectedToken,
                  tokenSelectBoxChanged: (selectedToken) {
                    insertWithdrawalPageCubit.setSelectedToken(
                      selectedToken: selectedToken,
                    );
                    tokenAmountCalculatorCubit.setSelectedToken(
                      tokenModel: selectedToken,
                    );
                  },
                ),
                TokenAmountCalculatorView(
                  tokenAmountCalculatorCubit: tokenAmountCalculatorCubit,
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
                onPressed: state.isValidWithdrawal
                    ? () {
                        final walletState = context.read<WalletCubit>().state;
                        Navigator.of(context).push<void>(
                          ConfirmWithdrawalPage.route(
                            selectedToken: state.selectedToken,
                            withdrawalAddress: widget.withdrawalAddress,
                            amount: state.amount,
                            selectedAccountSecretKey: walletState.cryptoAccount
                                .data[walletState.currentCryptoIndex].secretKey,
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
