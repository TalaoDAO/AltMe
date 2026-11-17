import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:wallet_ui/wallet_ui.dart';

class DiscoverCredentialCategoryItem extends StatelessWidget {
  const DiscoverCredentialCategoryItem({
    super.key,
    required this.dummyCredentials,
    required this.credentialCategory,
  });

  final List<DiscoverDummyCredential> dummyCredentials;
  final CredentialCategory credentialCategory;

  @override
  Widget build(BuildContext context) {
    if (dummyCredentials.isEmpty) {
      return const SizedBox.shrink();
    }
    final credentialCategoryConfig = credentialCategory.config(context.l10n);
    // Sorted by order, highest first.
    final sorted = List.of(dummyCredentials)
      ..sort(
        (a, b) => b.credentialSubjectType.order.compareTo(
          a.credentialSubjectType.order,
        ),
      );

    return Padding(
      padding: const EdgeInsets.only(bottom: WalletSpacing.xl),
      child: WalletCredentialList(
        title: credentialCategoryConfig.discoverTitle,
        subtitle: credentialCategoryConfig.discoverSubTitle,
        children: [
          for (final dummyCredential in sorted)
            DiscoverCredentialTile(dummyCredential: dummyCredential),
        ],
      ),
    );
  }
}
