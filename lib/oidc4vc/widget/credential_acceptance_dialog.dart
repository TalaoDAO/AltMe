import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:flutter/material.dart';

/// "Add credential to your wallet?" - shown before inserting a fetched
/// credential into the wallet, per ticket #3506.
class CredentialAcceptanceDialog extends StatelessWidget {
  const CredentialAcceptanceDialog({
    super.key,
    required this.credentialDisplayName,
    required this.issuerName,
    required this.isTrusted,
    required this.claims,
  });

  final String credentialDisplayName;
  final String issuerName;
  final bool isTrusted;
  final List<ClaimEntry> claims;

  static Future<bool> show({
    required BuildContext context,
    required String credentialDisplayName,
    required String issuerName,
    required bool isTrusted,
    required List<ClaimEntry> claims,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => CredentialAcceptanceDialog(
            credentialDisplayName: credentialDisplayName,
            issuerName: issuerName,
            isTrusted: isTrusted,
            claims: claims,
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: ConfirmDialog(
        title: l10n.credentialAcceptTitle,
        subtitle: credentialDisplayName,
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.issuedByLabel, style: textTheme.bodySmall),
                Text(issuerName, style: textTheme.titleMedium),
                const SizedBox(height: 8),
                TrustBadge(
                  isTrusted: isTrusted,
                  trustedLabel: l10n.trustedIssuerLabel,
                  notTrustedLabel: l10n.issuerNotVerifiedLabel,
                  notTrustedDescription: isTrusted
                      ? null
                      : l10n.issuerNotVerifiedDescription,
                ),
                if (claims.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.informationIncludedLabel,
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  ClaimList(claims: claims),
                ],
              ],
            ),
          ),
        ),
        yes: isTrusted ? l10n.addToWalletLabel : l10n.addLabel,
        no: l10n.decline,
        invertedCallToAction: !isTrusted,
      ),
    );
  }
}
