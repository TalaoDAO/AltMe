import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/nft/widgets/widgets.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NftPage extends StatefulWidget {
  const NftPage({super.key});

  @override
  State<NftPage> createState() => _NftPageState();
}

class _NftPageState extends State<NftPage>
    with AutomaticKeepAliveClientMixin<NftPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NftView();
  }
}

class NftView extends StatefulWidget {
  const NftView({super.key});

  @override
  _NftViewState createState() => _NftViewState();
}

class _NftViewState extends State<NftView> {
  Future<void> onRefresh() async {
    await context.read<NftCubit>().fetchFromZero();
  }

  void onItemClick(NftModel nftModel) {
    Navigator.of(context).push<void>(NftDetailsPage.route(nftModel: nftModel));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyCollectionText(),
          const SizedBox(height: Sizes.space2XSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: MyText(
              l10n.nftListSubtitle,
              maxLines: 3,
              style: Theme.of(context).textTheme.credentialCategorySubTitle,
            ),
          ),
          const SizedBox(height: Sizes.spaceXSmall),
          Center(
            child: TransparentInkWell(
              onTap: () {
                Navigator.of(context).push<void>(
                  ReceivePage.route(
                    accountAddress: context
                        .read<WalletCubit>()
                        .state
                        .currentAccount!
                        .walletAddress,
                    item: l10n.nft,
                    description: l10n.sendOnlyNftToThisAddressDescription,
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    IconStrings.addSquare,
                    width: Sizes.icon,
                    height: Sizes.icon,
                  ),
                  const SizedBox(width: Sizes.spaceXSmall),
                  Text(
                    l10n.receiveNft,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceNormal),
          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<ManageNetworkCubit, ManageNetworkState>(
                  listener: (context, state) {
                    onRefresh();
                  },
                ),
                BlocListener<NftCubit, NftState>(
                  listener: (context, state) {
                    if (state.status == AppStatus.loading) {
                      LoadingView().show(context: context);
                    } else {
                      LoadingView().hide();
                    }

                    if (state.message != null &&
                        (state.status != AppStatus.errorWhileFetching ||
                            state.status == AppStatus.error)) {
                      AlertMessage.showStateMessage(
                        context: context,
                        stateMessage: state.message!,
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<NftCubit, NftState>(
                builder: (_, state) {
                  String message = '';
                  if (state.message != null) {
                    final MessageHandler messageHandler =
                        state.message!.messageHandler!;
                    message =
                        messageHandler.getMessage(context, messageHandler);
                  }

                  final index =
                      context.read<WalletCubit>().state.currentCryptoIndex;

                  final blockchain = context
                      .read<WalletCubit>()
                      .state
                      .cryptoAccount
                      .data[index]
                      .blockchainType;

                  if (blockchain.isDisabled) {
                    return Center(
                      child: Text(l10n.thisFeatureIsNotSupportedMessage),
                    );
                  }

                  if (state.status == AppStatus.fetching) {
                    return const NftListShimmer();
                  } else if (state.status == AppStatus.populate) {
                    if (state.data.isEmpty) {
                      return ErrorView(
                        message: l10n.nftEmptyMessage,
                        onTap: onRefresh,
                      );
                    } else {
                      return NftList(
                        nftList: state.data,
                        onItemClick: onItemClick,
                        onRefresh: onRefresh,
                        onScrollEnded: () =>
                            context.read<NftCubit>().fetchMoreTezosNfts(),
                      );
                    }
                  } else if (state.status == AppStatus.errorWhileFetching) {
                    return ErrorView(message: message, onTap: onRefresh);
                  } else {
                    return NftList(
                      nftList: state.data,
                      onRefresh: onRefresh,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
