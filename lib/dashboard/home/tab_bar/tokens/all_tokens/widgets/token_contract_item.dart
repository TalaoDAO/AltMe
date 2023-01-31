import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class TokenContractItem extends StatelessWidget {
  const TokenContractItem({
    super.key,
    required this.tokenContractModel,
    this.isOn = false,
    required this.onChange,
  });

  final ContractModel tokenContractModel;
  final bool isOn;
  final dynamic Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        leading: CachedImageFromNetwork(
          tokenContractModel.iconUrl ?? '',
          width: Sizes.tokenLogoSize,
          height: Sizes.tokenLogoSize,
          borderRadius: const BorderRadius.all(
            Radius.circular(Sizes.tokenLogoSize),
          ),
        ),
        title: MyText(
          tokenContractModel.name ?? tokenContractModel.symbol,
          style: Theme.of(context).textTheme.listTileTitle,
          maxLength: 10,
        ),
        subtitle: MyText(
          tokenContractModel.symbol,
          style: Theme.of(context).textTheme.listTileSubtitle,
        ),
        trailing: Switcher(
          size: SwitcherSize.small,
          colorOn: Theme.of(context).colorScheme.primary,
          colorOff: Theme.of(context).colorScheme.cardBackground,
          onChanged: onChange,
          value: isOn,
        ),
      ),
    );
  }
}
