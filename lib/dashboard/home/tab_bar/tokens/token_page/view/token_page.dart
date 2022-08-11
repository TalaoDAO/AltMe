import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage>
    with AutomaticKeepAliveClientMixin<TokenPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const TokenView();
  }
}

class TokenView extends StatefulWidget {
  const TokenView({Key? key}) : super(key: key);

  @override
  _TokenViewState createState() => _TokenViewState();
}

class _TokenViewState extends State<TokenView> {
  int _offset = 0;
  final _limit = 15;
  int activeIndex = -1;

  Future<void> onRefresh() async {
    _offset = 0;
    await context.read<TokensCubit>().getBalanceOfAssetList(
          baseUrl: context.read<ManageNetworkCubit>().state.network.tzktUrl,
          offset: _offset,
        );
  }

  Future<void> onScrollEnded() async {
    _offset += _limit;
    LoadingView().show(context: context);
    await context.read<TokensCubit>().getBalanceOfAssetList(
          baseUrl:
              context.read<ProfileCubit>().state.model.tezosNetwork.tzktUrl,
          offset: _offset,
        );
    LoadingView().hide();
  }

  void onItemTap(TokenModel _) {
    // Navigator.of(context).push<void>(SendToPage.route());
    Navigator.of(context).push<void>(SendReceiveHomePage.route());
  }

  @override
  Widget build(BuildContext context) {
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
            const MyAssetsText(),
            const SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<TokensCubit, TokensState>(
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
                builder: (context, state) {
                  String message = '';
                  if (state.message != null) {
                    final MessageHandler messageHandler =
                        state.message!.messageHandler!;
                    message =
                        messageHandler.getMessage(context, messageHandler);
                  }

                  if (state.status == AppStatus.fetching) {
                    return const TokenListShimmer();
                  } else if (state.status == AppStatus.populate) {
                    return TokenList(
                      tokenList: state.data,
                      onRefresh: onRefresh,
                      onScrollEnded: onScrollEnded,
                      onItemTap: onItemTap,
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
