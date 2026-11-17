import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:wallet_ui/wallet_ui.dart';

class HomeCredentialCategoryItem extends StatelessWidget {
  const HomeCredentialCategoryItem({
    super.key,
    required this.credentials,
    required this.credentialCategory,
  });

  final List<CredentialModel> credentials;
  final CredentialCategory credentialCategory;

  @override
  Widget build(BuildContext context) {
    // Sorted by order, highest first.
    final sortedCredentials = List.of(credentials)
      ..sort(
        (a, b) => b
            .credentialPreview
            .credentialSubjectModel
            .credentialSubjectType
            .order
            .compareTo(
              a
                  .credentialPreview
                  .credentialSubjectModel
                  .credentialSubjectType
                  .order,
            ),
      );
    final credentialCategoryConfig = credentialCategory.config(context.l10n);
    return Padding(
      padding: const EdgeInsets.only(bottom: WalletSpacing.xl),
      child: WalletCredentialList(
        title: credentialCategoryConfig.homeTitle,
        subtitle: credentialCategoryConfig.homeSubTitle,
        footer: credentialCategory == CredentialCategory.pendingCards
            ? null
            : AddCredentialButton(credentialCategory: credentialCategory),
        children: [
          for (final credential in sortedCredentials)
            HomeCredentialItem(credentialModel: credential),
        ],
      ),
    );
  }
}
