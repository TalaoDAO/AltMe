import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titleColor = Theme.of(context).colorScheme.titleColor;
    final valueColor = Theme.of(context).colorScheme.valueColor;
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
          ),
          const SizedBox(height: 5),
          CredentialField(
            title: l10n.credentialDetailsPresented,
            value: UiDate.formatDate(activity.presentation!.presentedAt),
            titleColor: titleColor,
            valueColor: valueColor,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.credentialDetailsOrganisationDetail,
            style: Theme.of(context)
                .textTheme
                .credentialFieldTitle
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
                .credentialFieldDescription
                .copyWith(color: valueColor),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          )
        ],
        if (activity.acquisitionAt != null) ...[
          CredentialField(
            title: l10n.credentialDetailsInWalletSince,
            value: UiDate.formatDate(activity.acquisitionAt!),
            titleColor: titleColor,
            valueColor: valueColor,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 5),
        ],
        Divider(color: Theme.of(context).colorScheme.surfaceContainer),
      ],
    );
  }
}
