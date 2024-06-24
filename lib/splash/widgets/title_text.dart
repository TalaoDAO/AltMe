import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.profileModel,
  });

  final ProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final isEnterprise = profileModel.profileType == ProfileType.enterprise;

    final splashScreenTitle =
        profileModel.profileSetting.generalOptions.splashScreenTitle ??
            '${l10n.professional} ${l10n.wallet}';

    return Text(
      isEnterprise ? splashScreenTitle : '${Parameters.appName} ${l10n.wallet}',
      maxLines: 1,
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}
