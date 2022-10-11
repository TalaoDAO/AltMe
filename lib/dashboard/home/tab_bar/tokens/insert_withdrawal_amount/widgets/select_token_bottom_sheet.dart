import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTokenBottomSheet extends StatelessWidget {
  const SelectTokenBottomSheet({Key? key}) : super(key: key);

  static Future<TokenModel?> show(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Sizes.largeRadius),
          topLeft: Radius.circular(Sizes.largeRadius),
        ),
      ),
      context: context,
      builder: (_) => const SelectTokenBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _SelectTokenBottomSheetView();
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
  int activeIndex = -1;

  Future<void> onRefresh() async {
    await context.read<TokensCubit>().fetchFromZero();
  }

  Future<void> onScrollEnded() async {
    await context.read<TokensCubit>().fetchMoreTokens();
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
                  BlocListener<TokensCubit, TokensState>(
                    listener: (_, tokensState) {
                      if (tokensState.status == AppStatus.loading) {
                        LoadingView().show(context: context);
                      } else {
                        LoadingView().hide();
                      }

                      if (tokensState.message != null &&
                          tokensState.status != AppStatus.errorWhileFetching) {
                        AlertMessage.showStateMessage(
                          context: context,
                          stateMessage: tokensState.message!,
                        );
                      }
                    },
                  ),
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
                  child: BlocBuilder<TokensCubit, TokensState>(
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
                      } else if (state.status == AppStatus.populate ||
                          state.status == AppStatus.success) {
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
