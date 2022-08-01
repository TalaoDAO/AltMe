import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSelectBoxView extends StatelessWidget {
  const AccountSelectBoxView({Key? key, this.caption}) : super(key: key);

  final String? caption;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountSelectBoxCubit>(
      create: (context) => AccountSelectBoxCubit(
        walletCubit: context.read<WalletCubit>(),
      ),
      child: BlocBuilder<AccountSelectBoxCubit, AccountSelectBoxState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Sizes.normalRadius),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption != null)
                  Text(
                    caption!,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                SelectedAccountItem(
                  cryptoAccountData: state.accounts[state.selectedAccountIndex],
                  isBoxOpen: state.isBoxOpen,
                  onPressed: () {
                    context.read<AccountSelectBoxCubit>().toggleSelectBox();
                  },
                ),
                if (state.isBoxOpen)
                  ListView.separated(
                    itemCount: state.accounts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return SelectBoxAccountItem(
                        cryptoAccountData: state.accounts[i],
                        isSelected: state.selectedAccountIndex == i,
                        listIndex: i,
                        onPressed: () {
                          context.read<AccountSelectBoxCubit>()
                            ..setSelectedAccount(i)
                            ..toggleSelectBox();
                        },
                      );
                    },
                    separatorBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.spaceSmall,
                      ),
                      child: Divider(
                        height: 0.2,
                        color: Theme.of(context).colorScheme.borderColor,
                      ),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
