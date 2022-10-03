import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  const SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceLarge),
      child: SizedBox(
        child: Text(
          l10n.splashSubtitle,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.starterSubTitleStyle,
        ),
      ),
    );
  }
}
