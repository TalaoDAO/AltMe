import 'package:altme/app/shared/widget/base/background_card.dart';
import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// What a QES approval request asks the user to approve: the documents a
/// remote signing service will sign with the user's certificate, at which
/// level, and where.
class QesApprovalCard extends StatelessWidget {
  const QesApprovalCard({super.key, required this.request});

  final QesApprovalRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final signatureQualifier = request.signatureQualifier;
    final signingServices = request.locations
        .map((location) => Uri.tryParse(location)?.host ?? location)
        .where((host) => host.isNotEmpty)
        .toList();

    return BackgroundCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              l10n.qesApprovalTitle,
              style: theme.textTheme.titleLarge,
            ),
          ),
          CredentialField(
            title: l10n.qesApprovalDocuments,
            value: request.documentInfos.map((info) => info.label).join('\n'),
            titleColor: onSurface,
            valueColor: onSurface,
            showVertically: true,
          ),
          if (signatureQualifier != null)
            CredentialField(
              title: l10n.qesApprovalSignatureLevel,
              value: signatureQualifier == 'eu_eidas_qes'
                  ? l10n.qesSignatureQualifierQes
                  : signatureQualifier,
              titleColor: onSurface,
              valueColor: onSurface,
              showVertically: true,
            ),
          if (request.numSignatures != null)
            CredentialField(
              title: l10n.qesApprovalNumberOfSignatures,
              value: '${request.numSignatures}',
              titleColor: onSurface,
              valueColor: onSurface,
              showVertically: true,
            ),
          if (signingServices.isNotEmpty)
            CredentialField(
              title: l10n.qesApprovalSigningService,
              value: signingServices.join('\n'),
              titleColor: onSurface,
              valueColor: onSurface,
              showVertically: true,
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              l10n.qesApprovalConsent,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
