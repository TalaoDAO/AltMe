import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendToPage extends StatelessWidget {
  const SendToPage({super.key, this.defaultSelectedToken, this.nftModel});

  final TokenModel? defaultSelectedToken;
  final NftModel? nftModel;

  static Route<dynamic> route({
    TokenModel? defaultSelectedToken,
    NftModel? nftModel,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => SendToPage(
        defaultSelectedToken: defaultSelectedToken,
        nftModel: nftModel,
      ),
      settings: const RouteSettings(name: '/sendToPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SendToCubit(),
      child: SendToView(
        defaultSelectedToken: defaultSelectedToken,
        nftModel: nftModel,
      ),
    );
  }
}

class SendToView extends StatefulWidget {
  const SendToView({super.key, this.defaultSelectedToken, this.nftModel});

  final TokenModel? defaultSelectedToken;
  final NftModel? nftModel;

  @override
  State<SendToView> createState() => _SendToViewState();
}

class _SendToViewState extends State<SendToView>
    with SingleTickerProviderStateMixin {
  final TextEditingController withdrawalAddressController =
      TextEditingController();

  @override
  void initState() {
    withdrawalAddressController.addListener(() {
      context.read<SendToCubit>().setWithdrawalAddress(
        withdrawalAddress: withdrawalAddressController.text,
      );
    });
    super.initState();
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceXSmall),
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
                const SizedBox(height: Sizes.spaceXLarge),
                FromAccountWidget(isEnabled: widget.nftModel == null),
                const SizedBox(height: Sizes.spaceNormal),
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
                        if (widget.nftModel != null) {
                          final isTezos = widget.nftModel is TezosNftModel;
                          Navigator.of(context).push<void>(
                            ConfirmTokenTransactionPage.route(
                              selectedToken: isTezos
                                  ? (widget.nftModel! as TezosNftModel)
                                        .getToken()
                                  : (widget.nftModel! as EthereumNftModel)
                                        .getToken(),
                              withdrawalAddress: state.withdrawalAddress,
                              amount: '1',
                              isNFT: true,
                            ),
                          );
                        } else if (widget.defaultSelectedToken != null) {
                          Navigator.of(context).push<void>(
                            InsertWithdrawalAmountPage.route(
                              defualtSelectedToken:
                                  widget.defaultSelectedToken!,
                              withdrawalAddress: state.withdrawalAddress,
                            ),
                          );
                        }
                      },
              );
            },
          ),
        ),
      ),
    );
  }
}
