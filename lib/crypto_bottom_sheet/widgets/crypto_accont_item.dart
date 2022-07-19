import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/model/model.dart';
import 'package:flutter/material.dart';

class CryptoAccountItem extends StatelessWidget {
  const CryptoAccountItem({
    Key? key,
    required this.cryptoAccountData,
    required this.isSelected,
    required this.listIndex,
    required this.onPressed,
    required this.onEditButtonPressed,
  }) : super(key: key);

  final CryptoAccountData cryptoAccountData;
  final bool isSelected;
  final int listIndex;
  final VoidCallback onPressed;
  final VoidCallback onEditButtonPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final walletAddressLength = cryptoAccountData.walletAddress.length;
    final walletAddressExtracted = walletAddressLength > 0
        ? '''${cryptoAccountData.walletAddress.substring(0, walletAddressLength - 16)} ... ${cryptoAccountData.walletAddress.substring(cryptoAccountData.walletAddress.length - 5)}'''
        : '';

    return ListTile(
      onTap: onPressed,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: Checkbox(
        value: isSelected,
        fillColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.inversePrimary,
        ),
        checkColor: Theme.of(context).colorScheme.primary,
        onChanged: (_) => onPressed.call(),
        shape: const CircleBorder(),
      ),
      title: Row(
        children: [
          Flexible(
            child: MyText(
              cryptoAccountData.name.trim().isEmpty
                  ? '${l10n.cryptoAccount} ${listIndex + 1}'
                  : cryptoAccountData.name,
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.accountsListItemTitle,
            ),
          ),
          const SizedBox(width: Sizes.spaceXSmall),
          InkWell(
            onTap: onEditButtonPressed,
            child: Icon(
              Icons.edit,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: Sizes.spaceXSmall),
          if (cryptoAccountData.isImported)
            Chip(
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Sizes.smallRadius)),
              ),
              padding: EdgeInsets.zero,
              label: Text(
                l10n.imported.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            )
        ],
      ),
      subtitle: MyText(
        walletAddressExtracted,
        style: Theme.of(context).textTheme.walletAddress,
      ),
    );
  }
}
