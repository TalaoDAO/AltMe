import 'package:altme/app/shared/shared.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BiometricsSwitch extends StatelessWidget {
  const BiometricsSwitch({
    super.key,
    this.onChange,
    required this.value,
  });
  final dynamic Function(bool)? onChange;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BackgroundCard(
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      color: Theme.of(context).colorScheme.cardHighlighted,
      child: Row(
        children: [
          Image.asset(
            IconStrings.fingerprint2,
            width: Sizes.icon2x,
            height: Sizes.icon2x,
          ),
          const SizedBox(
            width: Sizes.spaceSmall,
          ),
          MyText(
            l10n.loginWithBiometricsOnBoarding,
            maxLines: 1,
            minFontSize: 10,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          MyText(
            ' (${l10n.option})',
            maxLines: 1,
            minFontSize: 10,
            style: Theme.of(context).textTheme.bodySmall2,
          ),
          const Spacer(),
          CupertinoSwitch(
            value: value,
            trackColor: Theme.of(context).colorScheme.surface,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: onChange,
          )
        ],
      ),
    );
  }
}
