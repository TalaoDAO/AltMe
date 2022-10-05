import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/nft/view/widgets/widgets.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:arago_wallet/wallet/cubit/wallet_cubit.dart';
import 'package:dio/dio.dart';
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
    return BlocProvider<NftCubit>(
      create: (context) => NftCubit(
        client: DioClient(
          context.read<ManageNetworkCubit>().state.network.tzktUrl,
          Dio(),
        ),
        walletCubit: context.read<WalletCubit>(),
      ),
      child: const NftView(),
    );
  }
}

class NftView extends StatefulWidget {
  const NftView({Key? key}) : super(key: key);

  @override
  _NftViewState createState() => _NftViewState();
}

class _NftViewState extends State<NftView> {
  int _offset = 0;
  final _limit = 15;
  int activeIndex = -1;

  Future<void> onRefresh() async {
    _offset = 0;
    await context.read<NftCubit>().getTezosNftList(
          baseUrl: context.read<ManageNetworkCubit>().state.network.tzktUrl,
          offset: _offset,
        );
  }

  Future<void> onScrollEnded() async {
    _offset += _limit;
    LoadingView().show(context: context);
    await context.read<NftCubit>().getTezosNftList(
          baseUrl:
              context.read<ProfileCubit>().state.model.tezosNetwork.tzktUrl,
          offset: _offset,
        );
    LoadingView().hide();
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

                  if (state.status == AppStatus.success) {
                    //some action
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
                        onScrollEnded: onScrollEnded,
                      );
                    }
                  } else if (state.status == AppStatus.errorWhileFetching) {
                    return ErrorView(message: message, onTap: onRefresh);
                  } else {
                    return NftList(
                      nftList: const [],
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
