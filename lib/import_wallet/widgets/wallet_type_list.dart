import 'package:altme/app/app.dart';
import 'package:altme/import_wallet/import_wallet.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

typedef OnItemTap = Function(WalletTypeModel);

class WalletTypeList extends StatelessWidget {
  const WalletTypeList({Key? key, this.onItemTap}) : super(key: key);

  final OnItemTap? onItemTap;

  @override
  Widget build(BuildContext context) {
    final data = getWalletTypes(context);
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (_, index) {
        return WalletTypeItem(
          model: data[index],
          onTap: () => onItemTap?.call(
            data[index],
          ),
        );
      },
      itemCount: data.length,
    );
  }

  List<WalletTypeModel> getWalletTypes(BuildContext context) {
    final l10n = context.l10n;
    return [
      WalletTypeModel(
        title: l10n.templeWallet,
        walletName: l10n.temple,
        type: ImportWalletTypes.Tezos,
        imagePath: IconStrings.templeWallet,
      ),
      WalletTypeModel(
        title: l10n.kukaiWallet,
        walletName: l10n.kukai,
        type: ImportWalletTypes.Tezos,
        imagePath: IconStrings.kukaiWallet,
      ),
      WalletTypeModel(
        title: l10n.metaMaskWallet,
        walletName: l10n.metaMask,
        type: ImportWalletTypes.Ethereum,
        imagePath: IconStrings.metaMaskWallet,
      ),
      WalletTypeModel(
        title: l10n.trustWallet,
        walletName: l10n.trustWallet,
        type: ImportWalletTypes.Ethereum,
        imagePath: IconStrings.trustWallet,
      ),
      WalletTypeModel(
        title: l10n.myetherwallet,
        walletName: l10n.myetherwallet,
        type: ImportWalletTypes.Ethereum,
        imagePath: IconStrings.myetherwallet,
      ),
      WalletTypeModel(
        title: l10n.exodusWallet,
        walletName: l10n.exodusWallet,
        type: ImportWalletTypes.Ethereum,
        imagePath: IconStrings.exodusWallet,
      ),
      WalletTypeModel(
        title: l10n.guardaWallet,
        walletName: l10n.guardaWallet,
        type: ImportWalletTypes.Ethereum,
        imagePath: IconStrings.guardaWallet,
      ),
      WalletTypeModel(
        title: l10n.otherWalletApp,
        walletName: l10n.other,
        type: ImportWalletTypes.None,
        imagePath: IconStrings.add,
      ),
    ];
  }
}
