import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTokenBottomSheet extends StatelessWidget {
  const SelectTokenBottomSheet({Key? key, required this.tokensCubit})
      : super(key: key);

  final TokensCubit tokensCubit;

  static Future<TokenModel?> show(
    BuildContext context,
    TokensCubit tokensCubit,
  ) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Sizes.largeRadius),
          topLeft: Radius.circular(Sizes.largeRadius),
        ),
      ),
      context: context,
      builder: (_) => SelectTokenBottomSheet(
        tokensCubit: tokensCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokensCubit>.value(
      value: tokensCubit,
      child: const _SelectTokenBottomSheetView(),
    );
  }
}

class _SelectTokenBottomSheetView extends StatefulWidget {
  const _SelectTokenBottomSheetView({Key? key}) : super(key: key);

  @override
  State<_SelectTokenBottomSheetView> createState() =>
      _SelectTokenBottomSheetViewState();
}

class _SelectTokenBottomSheetViewState
    extends State<_SelectTokenBottomSheetView> {
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

  void onItemTap(TokenModel tokenModel) {
    Navigator.of(context).pop(tokenModel);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.inversePrimary,
            blurRadius: 5,
            spreadRadius: -3,
          )
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Sizes.largeRadius),
          topLeft: Radius.circular(Sizes.largeRadius),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.selectToken,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              MultiBlocListener(
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
                child: Expanded(
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
                        return TokenList(
                          tokenList: const [],
                          onRefresh: onRefresh,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
