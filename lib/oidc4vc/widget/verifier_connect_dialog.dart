import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// "Connect to {Verifier}?" - shown before reviewing the information
/// requested by the Verifier, per ticket #3506.
class VerifierConnectDialog extends StatelessWidget {
  const VerifierConnectDialog({
    super.key,
    required this.verifierName,
    required this.isTrusted,
    this.purpose,
  });

  final String verifierName;
  final bool isTrusted;
  final String? purpose;

  static Future<bool> show({
    required BuildContext context,
    required String verifierName,
    required bool isTrusted,
    String? purpose,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => VerifierConnectDialog(
            verifierName: verifierName,
            isTrusted: isTrusted,
            purpose: purpose,
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
        title: l10n.verifierConnectTitle(verifierName),
        subtitle: l10n.verifierConnectSubtitle(verifierName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrustBadge(
              isTrusted: isTrusted,
              trustedLabel: l10n.verifiedOrganisationLabel,
              notTrustedLabel: l10n.organisationNotVerifiedLabel,
              notTrustedDescription: isTrusted
                  ? null
                  : '${l10n.organisationNotVerifiedDescription}\n\n'
                      '${l10n.onlyContinueIfTrustOrganisation}',
            ),
            if (purpose != null && purpose!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l10n.purposeLabel, style: textTheme.bodySmall),
              Text(purpose!, style: textTheme.titleMedium),
            ],
          ],
        ),
        yes: isTrusted ? l10n.reviewRequestLabel : l10n.continueAnywayLabel,
        no: l10n.cancel,
        invertedCallToAction: !isTrusted,
      ),
    );
  }
}
