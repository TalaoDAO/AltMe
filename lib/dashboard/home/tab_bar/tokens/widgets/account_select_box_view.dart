import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSelectBoxView extends StatefulWidget {
  const AccountSelectBoxView({
    Key? key,
    this.isEnabled = true,
  }) : super(key: key);

  final bool isEnabled;

  @override
  State<AccountSelectBoxView> createState() => _AccountSelectBoxViewState();
}

class _AccountSelectBoxViewState extends State<AccountSelectBoxView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        return BackgroundCard(
          color: Theme.of(context).colorScheme.cardBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isEnabled)
                SelectedAccountItem(
                  cryptoAccountData: walletState
                      .cryptoAccount.data[walletState.currentCryptoIndex],
                  isBoxOpen: true,
                  onPressed: widget.isEnabled ? null : null,
                ),
              if (widget.isEnabled)
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor:
                        Theme.of(context).colorScheme.onPrimary,
                    dividerColor: Theme.of(context).colorScheme.cardBackground,
                    splashColor: Theme.of(context).colorScheme.transparent,
                    highlightColor: Theme.of(context).colorScheme.transparent,
                    colorScheme: ColorScheme.dark(
                      primary: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: SelectedAccountItem(
                      cryptoAccountData: walletState
                          .cryptoAccount.data[walletState.currentCryptoIndex],
                      isBoxOpen: true,
                      onPressed: widget.isEnabled ? null : null,
                    ),
                    children: <Widget>[
                      ListView.separated(
                        itemCount: walletState.cryptoAccount.data.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return SelectBoxAccountItem(
                            cryptoAccountData:
                                walletState.cryptoAccount.data[i],
                            isSelected: walletState.currentCryptoIndex == i,
                            listIndex: i,
                            onPressed: () {
                              //accountSelectBoxCubit..toggleSelectBox();

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
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
