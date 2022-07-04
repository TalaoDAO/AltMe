import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TokenPage extends StatelessWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokensCubit>(
      create: (context) => TokensCubit(
        client: DioClient(
          context.read<ProfileCubit>().state.model.tezosNetwork.tzktUrl,
          Dio(),
        ),
        walletCubit: context.read<WalletCubit>(),
      ),
      child: const TokenView(),
    );
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
    await context.read<TokensCubit>().getBalanceOfAssetList(offset: _offset);
  }

  Future<void> onScrollEnded() async {
    _offset += _limit;
    LoadingView().show(context: context);
    await context.read<TokensCubit>().getBalanceOfAssetList(offset: _offset);
    LoadingView().hide();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (activeIndex != state.currentCryptoIndex) {
          onRefresh();
        }
        activeIndex = state.currentCryptoIndex;
      },
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
