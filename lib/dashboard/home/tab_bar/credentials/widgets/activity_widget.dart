import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({
    super.key,
    required this.activity,
    required this.showVertically,
  });

  final Activity activity;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titleColor = Theme.of(context).colorScheme.onSurface;
    final valueColor = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        if (activity.presentation != null) ...[
          CredentialField(
            title: l10n.credentialDetailsOrganisation,
            value: activity.presentation!.issuer.preferredName,
            titleColor: titleColor,
            valueColor: valueColor,
            padding: EdgeInsets.zero,
            showVertically: showVertically,
          ),
          const SizedBox(height: 5),
          CredentialField(
            title: l10n.credentialDetailsPresented,
            value: UiDate.formatDate(activity.presentation!.presentedAt),
            titleColor: titleColor,
            valueColor: valueColor,
            padding: EdgeInsets.zero,
            showVertically: showVertically,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.credentialDetailsOrganisationDetail,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: titleColor),
          ),
          const SizedBox(height: 5),
          Text(
            activity.presentation!.issuer.organizationInfo.currentAddress
                    .isNotEmpty
                ? activity.presentation!.issuer.organizationInfo.currentAddress
                : activity.presentation!.issuer.organizationInfo.website,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: valueColor),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (activity.acquisitionAt != null) ...[
          CredentialField(
            title: l10n.credentialDetailsInWalletSince,
            value: UiDate.formatDate(activity.acquisitionAt),
            titleColor: titleColor,
            valueColor: valueColor,
            padding: EdgeInsets.zero,
            showVertically: showVertically,
          ),
          const SizedBox(height: 5),
        ],
        Divider(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.07),
        ),
      ],
    );
  }
}
