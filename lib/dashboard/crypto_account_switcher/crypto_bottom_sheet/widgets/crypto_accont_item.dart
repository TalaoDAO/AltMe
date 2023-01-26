import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/model/model.dart';
import 'package:flutter/material.dart';

class CryptoAccountItem extends StatelessWidget {
  const CryptoAccountItem({
    super.key,
    required this.cryptoAccountData,
    required this.isSelected,
    required this.listIndex,
    required this.onPressed,
    required this.onEditButtonPressed,
  });

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
          Image.asset(
            cryptoAccountData.blockchainType.icon,
            width: Sizes.icon,
          ),
          const SizedBox(width: Sizes.spaceXSmall),
          Flexible(
            child: MyText(
              cryptoAccountData.name.trim().isEmpty
                  ? l10n.unknown
                  : cryptoAccountData.name,
              maxLength: 30,
              maxLines: 1,
              minFontSize: 14,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.title,
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
          if (cryptoAccountData.isImported) const ImportedTag()
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceXSmall),
        child: MyText(
          walletAddressExtracted,
          style: Theme.of(context).textTheme.walletAddress,
        ),
      ),
    );
  }
}
