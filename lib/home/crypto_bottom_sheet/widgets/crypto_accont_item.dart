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
    final walletAddressExtracted = cryptoAccountData.walletAddress != ''
        ? '''${cryptoAccountData.walletAddress.substring(0, 8)} ... ${cryptoAccountData.walletAddress.substring(cryptoAccountData.walletAddress.length - 5)}'''
        : '';

    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.cryptoAccountNotSelected,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              InkWell(
                onTap: onEditButtonPressed,
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MyText(
                  cryptoAccountData.name.isEmpty
                      ? '${l10n.cryptoAccount} ${listIndex + 1}'
                      : cryptoAccountData.name,
                  style: Theme.of(context).textTheme.accountsName,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: MyText(
                    walletAddressExtracted,
                    style: Theme.of(context).textTheme.walletAddress,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
