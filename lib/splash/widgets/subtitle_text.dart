import 'package:altme/app/shared/enum/enum.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  const SubTitle({
    super.key,
    required this.profileModel,
  });

  final ProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final isEnterprise = profileModel.profileType == ProfileType.enterprise;
    final tag = profileModel.profileSetting.generalOptions.tagLine;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        isEnterprise ? tag : l10n.splashSubtitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
