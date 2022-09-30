import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/import_wallet/import_wallet.dart';
import 'package:arago_wallet/l10n/l10n.dart';
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
        type: ImportWalletTypes.temple,
        imagePath: IconStrings.templeWallet,
      ),
      // WalletTypeModel(
      //   name: l10n.metaMaskWallet,
      //   walletName: l10n.metaMask,
      //   type: ImportWalletTypes.metamask,
      //   imagePath: IconStrings.metaMaskWallet,
      // ),
      WalletTypeModel(
        title: l10n.kukaiWallet,
        walletName: l10n.kukai,
        type: ImportWalletTypes.kukai,
        imagePath: IconStrings.kukaiWallet,
      ),
      WalletTypeModel(
        title: l10n.otherWalletApp,
        walletName: l10n.other,
        type: ImportWalletTypes.other,
        imagePath: IconStrings.add,
      ),
    ];
  }
}
