import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSelectBoxView extends StatefulWidget {
  const AccountSelectBoxView({Key? key, this.caption, this.controller})
      : super(key: key);

  final String? caption;
  final AccountSelectBoxController? controller;

  @override
  State<AccountSelectBoxView> createState() => _AccountSelectBoxViewState();
}

class _AccountSelectBoxViewState extends State<AccountSelectBoxView> {
  late final AccountSelectBoxCubit accountSelectBoxCubit =
      AccountSelectBoxCubit(
    accounts: context.read<WalletCubit>().state.cryptoAccount.data,
    selectedAccountIndex: context.read<WalletCubit>().state.currentCryptoIndex,
  );

  @override
  void initState() {
    widget.controller?.setSelectedAccount(
      selectedAccount: context
          .read<WalletCubit>()
          .state
          .cryptoAccount
          .data[context.read<WalletCubit>().state.currentCryptoIndex],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountSelectBoxCubit>(
      create: (context) => accountSelectBoxCubit,
      child: BlocBuilder<AccountSelectBoxCubit, AccountSelectBoxState>(
        builder: (context, state) {
          widget.controller?.setSelectedAccount(
            selectedAccount: state.accounts[state.selectedAccountIndex],
          );

          return BlocBuilder<WalletCubit, WalletState>(
            builder: (context, walletState) {
              if (state.accounts != walletState.cryptoAccount.data) {
                accountSelectBoxCubit
                    .setAccounts(walletState.cryptoAccount.data);
              }

              if (state.selectedAccountIndex !=
                  walletState.currentCryptoIndex) {
                accountSelectBoxCubit
                    .setSelectedAccount(walletState.currentCryptoIndex);
              }

              return Container(
                padding: const EdgeInsets.all(Sizes.spaceSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Sizes.normalRadius),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.caption != null)
                      Text(
                        widget.caption!,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    SelectedAccountItem(
                      cryptoAccountData:
                          state.accounts[state.selectedAccountIndex],
                      isBoxOpen: state.isBoxOpen,
                      onPressed: accountSelectBoxCubit.toggleSelectBox,
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
                              accountSelectBoxCubit
                                ..setSelectedAccount(i)
                                ..toggleSelectBox();
                              context
                                  .read<WalletCubit>()
                                  .setCurrentWalletAccount(i);
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
          );
        },
      ),
    );
  }
}
