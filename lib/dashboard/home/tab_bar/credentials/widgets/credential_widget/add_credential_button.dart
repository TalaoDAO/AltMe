import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_ui/wallet_ui.dart';

class AddCredentialButton extends StatelessWidget {
  const AddCredentialButton({super.key, required this.credentialCategory});

  final CredentialCategory credentialCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WalletButton(
      label: l10n.addCards,
      variant: WalletButtonVariant.secondary,
      icon: const WalletIcon(WalletIconStrings.add),
      expand: true,
      onPressed: () {
        if (credentialCategory == CredentialCategory.blockchainAccountsCards) {
          Navigator.of(context).push<void>(ChooseAddAccountMethodPage.route());
        } else {
          context.read<DashboardCubit>().selectTab(DashboardTab.discover);
        }
      },
    );
  }
}
