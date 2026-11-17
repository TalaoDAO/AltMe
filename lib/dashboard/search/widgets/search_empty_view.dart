import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:wallet_ui/wallet_ui.dart';

/// Shown when the typed text matches no credential.
class SearchEmptyView extends StatelessWidget {
  const SearchEmptyView({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WalletSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: WalletSpacing.s,
          children: [
            Text(
              l10n.searchNoResults,
              textAlign: TextAlign.center,
              style: context.walletTypography.displaySSemibold.copyWith(
                color: context.walletColors.contentDefault,
              ),
            ),
            Text(
              l10n.searchNoResultsDescription(query.trim()),
              textAlign: TextAlign.center,
              style: context.walletTypography.bodyMRegular.copyWith(
                color: context.walletColors.contentNeutral,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
