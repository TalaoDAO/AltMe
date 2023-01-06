import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TokensPage extends StatefulWidget {
  const TokensPage({Key? key}) : super(key: key);

  @override
  State<TokensPage> createState() => _TokensPageState();
}

class _TokensPageState extends State<TokensPage>
    with AutomaticKeepAliveClientMixin<TokensPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const TokensView();
  }
}

class TokensView extends StatefulWidget {
  const TokensView({Key? key}) : super(key: key);

  @override
  _TokensViewState createState() => _TokensViewState();
}

class _TokensViewState extends State<TokensView> {
  Future<void> onRefresh() async {
    await context.read<TokensCubit>().fetchFromZero();
  }

  Future<void> onScrollEnded() async {
    await context.read<TokensCubit>().fetchMoreTokens();
  }

  void onItemTap(TokenModel selectedToken) {
    Navigator.of(context).push<void>(
      SendReceiveHomePage.route(
        selectedToken: selectedToken,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<ManageNetworkCubit, ManageNetworkState>(
          listener: (context, state) {
            onRefresh();
          },
        ),
        BlocListener<TokensCubit, TokensState>(
          listener: (context, state) {
            if (state.status == AppStatus.loading) {
              LoadingView().show(context: context);
            } else {
              LoadingView().hide();
            }
            if (state.message != null &&
                state.status != AppStatus.errorWhileFetching) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: state.message!,
              );
            }
          },
        ),
      ],
      child: BasePage(
        scrollView: false,
        padding: EdgeInsets.zero,
        backgroundColor: Theme.of(context).colorScheme.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyAssetsText(),
            const SizedBox(height: Sizes.space2XSmall),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MyText(
                l10n.tokenListSubtitle,
                maxLines: 3,
                style: Theme.of(context).textTheme.credentialCategorySubTitle,
              ),
            ),
            const SizedBox(height: Sizes.spaceXSmall),
            BlocBuilder<TokensCubit, TokensState>(
              builder: (context, state) {
                final index =
                    context.read<WalletCubit>().state.currentCryptoIndex;

                final blockchain = context
                    .read<WalletCubit>()
                    .state
                    .cryptoAccount
                    .data[index]
                    .blockchainType;

                if (blockchain.isdisabled) {
                  return const Center();
                }

                return Column(
                  children: [
                    TotalWalletBalance(
                      tokensCubit: context.read<TokensCubit>(),
                    ),
                    if (blockchain == BlockchainType.tezos)
                      const SizedBox(
                        height: Sizes.spaceSmall,
                      ),
                    if (blockchain == BlockchainType.tezos)
                      AddTokenButton(
                        onTap: () {
                          Navigator.of(context)
                              .push<void>(
                                AllTokensPage.route(),
                              )
                              .then(
                                (value) =>
                                    context.read<TokensCubit>().fetchFromZero(),
                              );
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: Sizes.spaceSmall,
            ),
            Expanded(
              child: BlocConsumer<TokensCubit, TokensState>(
                listener: (context, state) {
                  if (state.status == AppStatus.loading) {
                    LoadingView().show(context: context);
                  } else {
                    LoadingView().hide();
                  }

                  if (state.message != null &&
                          state.status == AppStatus.error ||
                      state.status == AppStatus.errorWhileFetching) {
                    AlertMessage.showStateMessage(
                      context: context,
                      stateMessage: state.message!,
                    );
                  }

                  if (state.status == AppStatus.success) {
                    //some action
                  }
                },
                builder: (context, state) {
                  final index =
                      context.read<WalletCubit>().state.currentCryptoIndex;

                  final blockchain = context
                      .read<WalletCubit>()
                      .state
                      .cryptoAccount
                      .data[index]
                      .blockchainType;

                  if (blockchain.isdisabled) {
                    return Center(
                      child: Text(l10n.thisFeatureIsNotSupportedMessage),
                    );
                  }
                  String message = '';
                  if (state.message != null) {
                    final MessageHandler messageHandler =
                        state.message!.messageHandler!;
                    message =
                        messageHandler.getMessage(context, messageHandler);
                  }

                  if (state.status == AppStatus.fetching) {
                    return const TokenListShimmer();
                  } else if (state.status == AppStatus.populate ||
                      state.status == AppStatus.success) {
                    return TokenList(
                      tokenList: state.data,
                      onRefresh: onRefresh,
                      onScrollEnded: onScrollEnded,
                      onItemTap: onItemTap,
                      isSecure: state.isSecure,
                    );
                  } else if (state.status == AppStatus.errorWhileFetching) {
                    return ErrorView(message: message, onTap: onRefresh);
                  } else {
                    return TokenList(tokenList: const [], onRefresh: onRefresh);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
