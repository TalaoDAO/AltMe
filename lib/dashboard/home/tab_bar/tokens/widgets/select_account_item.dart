import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/model/model.dart';
import 'package:flutter/material.dart';

class SelectedAccountItem extends StatelessWidget {
  const SelectedAccountItem({
    super.key,
    required this.cryptoAccountData,
    required this.isBoxOpen,
    required this.onPressed,
    required this.title,
  });

  final CryptoAccountData cryptoAccountData;
  final bool isBoxOpen;
  final VoidCallback? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        ListTile(
          onTap: onPressed,
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          visualDensity: const VisualDensity(vertical: -3, horizontal: 0),
          title: MyText(
            cryptoAccountData.name.trim().isEmpty
                ? l10n.unknown
                : cryptoAccountData.name,
            maxLines: 1,
            minFontSize: 12,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: Sizes.spaceXSmall),
            child: MyText(
              cryptoAccountData.walletAddress,
              maxLines: 2,
              style: Theme.of(context).textTheme.walletAddress,
            ),
          ),
          trailing: onPressed == null
              ? null
              : Icon(
                  isBoxOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: Sizes.icon2x,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
        ),
      ],
    );
  }
}
