import 'package:altme/dashboard/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToAccountWidget extends StatelessWidget {
  const ToAccountWidget({
    super.key,
    this.isEnabled = true,
    required this.onAccountSelected,
    this.triggerInitialAccount = false,
  });

  final bool isEnabled;
  final Function(CryptoAccountData?) onAccountSelected;
  final bool triggerInitialAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        final accounts = walletState.cryptoAccount.data
            .where(
              (element) =>
                  (element.blockchainType ==
                      walletState.currentAccount!.blockchainType) &&
                  (walletState.currentAccount != element),
            )
            .toList();
        if (accounts.isEmpty) {
          if (triggerInitialAccount) {
            onAccountSelected.call(null);
          }
          return Center(
            child: Text(l10n.thereIsNoAccountInYourWallet),
          );
        } else {
          if (triggerInitialAccount) {
            onAccountSelected.call(accounts.first);
          }
          return AccountSelectBoxView(
            title: l10n.to,
            accounts: accounts,
            selectedAccountIndex: 0,
            onSelectAccount: (accountData, index) {
              onAccountSelected.call(accountData);
            },
          );
        }
      },
    );
  }
}
