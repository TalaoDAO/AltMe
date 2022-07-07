import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
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
        return WalletTypeItem(model: data[index]);
      },
      itemCount: data.length,
    );
  }

  List<WalletTypeModel> getWalletTypes(BuildContext context) {
    final l10n = context.l10n;
    return [
      WalletTypeModel(
        name: l10n.templeWallet,
        type: ImportWalletTypes.temple,
        imagePath: IconStrings.templeWallet,
      ),
      WalletTypeModel(
        name: l10n.metaMaskWallet,
        type: ImportWalletTypes.metamask,
        imagePath: IconStrings.metaMaskWallet,
      ),
      WalletTypeModel(
        name: l10n.kukaiWallet,
        type: ImportWalletTypes.kukai,
        imagePath: IconStrings.kukaiWallet,
      ),
      WalletTypeModel(
        name: l10n.otherWalletApp,
        type: ImportWalletTypes.other,
        imagePath: IconStrings.add,
      ),
    ];
  }
}
