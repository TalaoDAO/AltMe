import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef TokenSelectBoxChanged = Function(TokenModel);

class TokenSelectBoxView extends StatelessWidget {
  const TokenSelectBoxView({
    Key? key,
    required this.selectedToken,
  }) : super(key: key);

  final TokenModel selectedToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokenSelectBoxCubit>(
      create: (_) => TokenSelectBoxCubit(
        insertWithdrawalPageCubit: context.read<InsertWithdrawalPageCubit>(),
        tokensCubit: context.read<TokensCubit>(),
      ),
      child: _TokenSelectBox(selectedToken: selectedToken),
    );
  }
}

class _TokenSelectBox extends StatefulWidget {
  const _TokenSelectBox({
    Key? key,
    required this.selectedToken,
  }) : super(key: key);

  final TokenModel selectedToken;

  @override
  State<_TokenSelectBox> createState() => _TokenSelectBoxState();
}

class _TokenSelectBoxState extends State<_TokenSelectBox> {
  @override
  void initState() {
    context.read<TokenSelectBoxCubit>().getBalanceOfAssetList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        //TODO(all) : do some adjustment
        BlocListener<WalletCubit, WalletState>(
          listenWhen: (previous, current) =>
              current.currentCryptoIndex != previous.currentCryptoIndex,
          listener: (context, walletState) {
            //when walletState changed we need to update TokensCubit because it
            // used walletCubit inside itself
            context.read<TokenSelectBoxCubit>().getBalanceOfAssetList();
          },
        ),
      ],
      child: _TokenSelectBoxItem(selectedToken: widget.selectedToken),
    );
  }
}

class _TokenSelectBoxItem extends StatelessWidget {
  const _TokenSelectBoxItem({
    Key? key,
    required this.selectedToken,
  }) : super(key: key);

  final TokenModel selectedToken;

  @override
  Widget build(BuildContext context) {
    final TokenModel tokenModel = selectedToken;
    return BlocBuilder<TokenSelectBoxCubit, TokenSelectBoxState>(
      builder: (context, state) {
        return state.isLoading
            ? const TokenItemShimmer()
            : InkWell(
                onTap: () async {
                  final selectedToken = await SelectTokenBottomSheet.show(
                    context,
                  );
                  if (selectedToken != null) {
                    context
                        .read<TokenSelectBoxCubit>()
                        .setSelectedToken(tokenModel: selectedToken);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(Sizes.spaceSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.normalRadius),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(Sizes.smallRadius),
                            ),
                            child: SizedBox(
                              width: Sizes.icon2x,
                              height: Sizes.icon2x,
                              child: CachedImageFromNetwork(
                                tokenModel.iconUrl ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Sizes.spaceXSmall,
                          ),
                          MyText(
                            tokenModel.name.isEmpty
                                ? tokenModel.symbol
                                : tokenModel.name,
                            maxLength: 10,
                            style: Theme.of(context).textTheme.listTileTitle,
                            minFontSize: 10,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: Sizes.spaceXSmall,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: Sizes.icon,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          MyText(
                            tokenModel.calculatedBalance,
                            minFontSize: 10,
                            maxLength: 15,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                          MyText(
                            tokenModel.symbol,
                            minFontSize: 10,
                            maxLength: 10,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      MyText(
                        // TODO(Taleb): show usd value of token
                        r'$--.--',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.greyText,
                            ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
