import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
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
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.issuer,
          value: credentialModel.pendingInfo!.issuer ?? '',
          titleColor: Theme.of(context).colorScheme.titleColor,
          valueColor: Theme.of(context).colorScheme.valueColor,
          showVertically: showVertically,
        ),
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.dateOfRequest,
          value: UiDate.formatDate(
            credentialModel.pendingInfo!.requestedAt,
          ),
          titleColor: Theme.of(context).colorScheme.titleColor,
          valueColor: Theme.of(context).colorScheme.valueColor,
          showVertically: showVertically,
        ),
      ],
    );
  }
}
