import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DeferredCredentialData extends StatelessWidget {
  const DeferredCredentialData({
    super.key,
    required this.credentialModel,
    required this.showVertically,
  });

  final CredentialModel credentialModel;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.issuer,
          value: credentialModel.pendingInfo!.issuer ?? '',
          titleColor: Theme.of(context).colorScheme.onSurface,
          valueColor: Theme.of(context).colorScheme.onSurface,
          showVertically: showVertically,
        ),
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.dateOfRequest,
          value: UiDate.formatDate(credentialModel.pendingInfo!.requestedAt),
          titleColor: Theme.of(context).colorScheme.onSurface,
          valueColor: Theme.of(context).colorScheme.onSurface,
          showVertically: showVertically,
        ),
      ],
    );
  }
}
