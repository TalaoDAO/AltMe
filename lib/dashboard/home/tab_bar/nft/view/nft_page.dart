import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/nft/view/widgets/widgets.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NftPage extends StatefulWidget {
  const NftPage({Key? key}) : super(key: key);

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
  const NftView({Key? key}) : super(key: key);

  @override
  _NftViewState createState() => _NftViewState();
}

class _NftViewState extends State<NftView> {
  int activeIndex = -1;

  Future<void> onRefresh() async {
    await context.read<NftCubit>().onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletCubit, WalletState>(
          listener: (context, state) {
            if (activeIndex != state.currentCryptoIndex) {
              onRefresh();
            }
            activeIndex = state.currentCryptoIndex;
          },
        ),
        BlocListener<ManageNetworkCubit, ManageNetworkState>(
          listener: (context, state) {
            onRefresh();
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
            const MyCollectionText(),
            Expanded(
              child: BlocConsumer<NftCubit, NftState>(
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
                builder: (_, state) {
                  String message = '';
                  if (state.message != null) {
                    final MessageHandler messageHandler =
                        state.message!.messageHandler!;
                    message =
                        messageHandler.getMessage(context, messageHandler);
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
          ],
        ),
      ),
    );
  }
}
