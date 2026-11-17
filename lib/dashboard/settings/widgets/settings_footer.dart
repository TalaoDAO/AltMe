import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:wallet_ui/wallet_ui.dart';

/// The bottom of Settings: the enterprise block when there is one, the logo
/// and the app version.
class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key, required this.profileModel});

  final ProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typography = context.walletTypography;
    final generalOptions = profileModel.profileSetting.generalOptions;

    return Padding(
      padding: const EdgeInsets.only(top: WalletSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profileModel.profileType == ProfileType.enterprise) ...[
            Text(generalOptions.companyName, style: typography.bodyMSemibold),
            const SizedBox(height: WalletSpacing.s),
            Text(
              '${l10n.profileName} : ${generalOptions.profileName}',
              style: typography.bodySRegular,
            ),
            Text(
              '${l10n.configFileIdentifier} : ${generalOptions.profileId}',
              style: typography.bodySRegular,
            ),
            const SizedBox(height: WalletSpacing.m),
          ],
          const DrawerLogo(),
          const AppVersionDrawer(),
        ],
      ),
    );
  }
}
