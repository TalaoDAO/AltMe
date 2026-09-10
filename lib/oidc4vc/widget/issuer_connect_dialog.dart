import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// "Connect to credential issuer?" - shown before starting the interaction
/// with the Issuer, per ticket #3506.
class IssuerConnectDialog extends StatelessWidget {
  const IssuerConnectDialog({
    super.key,
    required this.issuerName,
    required this.isTrusted,
    required this.credentialDisplayName,
    this.logoUri,
  });

  final String issuerName;
  final bool isTrusted;
  final String credentialDisplayName;
  final String? logoUri;

  static Future<bool> show({
    required BuildContext context,
    required String issuerName,
    required bool isTrusted,
    required String credentialDisplayName,
    String? logoUri,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => IssuerConnectDialog(
            issuerName: issuerName,
            isTrusted: isTrusted,
            credentialDisplayName: credentialDisplayName,
            logoUri: logoUri,
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
        title: l10n.issuerConnectTitle,
        subtitle: l10n.issuerConnectSubtitle(issuerName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logoUri != null) ...[
              Center(
                child: CachedImageFromNetwork(logoUri!, height: 48, width: 48),
              ),
              const SizedBox(height: 16),
            ],
            TrustBadge(
              isTrusted: isTrusted,
              trustedLabel: l10n.trustedIssuerLabel,
              notTrustedLabel: l10n.issuerNotVerifiedLabel,
              notTrustedDescription: isTrusted
                  ? null
                  : '${l10n.issuerNotVerifiedDescription}\n\n'
                        '${l10n.onlyContinueIfTrustIssuer}',
            ),
            const SizedBox(height: 16),
            Text(l10n.credential, style: textTheme.bodyMedium),
            Text(credentialDisplayName, style: textTheme.titleMedium),
          ],
        ),
        yes: l10n.continueLabel,
        no: l10n.cancel,
        invertedCallToAction: !isTrusted,
      ),
    );
  }
}
