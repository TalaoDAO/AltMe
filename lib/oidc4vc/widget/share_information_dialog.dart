import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:flutter/material.dart';

/// "Share your information?" - shown right before disclosing information to
/// a Verifier, showing exactly the claims that will be shared, per ticket
/// #3506.
class ShareInformationDialog extends StatelessWidget {
  const ShareInformationDialog({
    super.key,
    required this.verifierName,
    required this.isTrusted,
    required this.claims,
    this.purpose,
  });

  final String verifierName;
  final bool isTrusted;
  final List<ClaimEntry> claims;
  final String? purpose;

  static Future<bool> show({
    required BuildContext context,
    required String verifierName,
    required bool isTrusted,
    required List<ClaimEntry> claims,
    String? purpose,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => ShareInformationDialog(
            verifierName: verifierName,
            isTrusted: isTrusted,
            claims: claims,
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
        title: l10n.shareInformationTitle,
        subtitle: l10n.shareInformationSubtitle(verifierName),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isTrusted) ...[
                  TrustBadge(
                    isTrusted: false,
                    trustedLabel: l10n.verifiedOrganisationLabel,
                    notTrustedLabel: l10n.organisationNotVerifiedLabel,
                    notTrustedDescription:
                        '${l10n.organisationNotVerifiedDescription}\n\n'
                        '${l10n.onlyShareIfTrustOrganisation}',
                  ),
                  const SizedBox(height: 16),
                ],
                if (purpose != null && purpose!.isNotEmpty) ...[
                  Text(l10n.purposeLabel, style: textTheme.bodySmall),
                  Text(purpose!, style: textTheme.titleMedium),
                  const SizedBox(height: 16),
                ],
                Text(
                  l10n.informationRequestedLabel,
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                ClaimList(claims: claims),
                const SizedBox(height: 8),
                Text(l10n.sharedWithLabel, style: textTheme.bodySmall),
                Text(verifierName, style: textTheme.titleMedium),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      isTrusted
                          ? IconStrings.shieldTick
                          : IconStrings.alertWarningIcon,
                      width: 16,
                      height: 16,
                      color: isTrusted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isTrusted
                          ? l10n.verifiedOrganisationLabel
                          : l10n.notVerifiedLabel,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.onlyInformationShownWillBeShared,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        yes: isTrusted
            ? l10n.shareInformationButtonLabel
            : l10n.shareAnywayLabel,
        no: l10n.dontShareLabel,
        invertedCallToAction: !isTrusted,
      ),
    );
  }
}
