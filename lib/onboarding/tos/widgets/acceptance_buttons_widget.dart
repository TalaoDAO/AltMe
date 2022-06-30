import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/onboarding/tos/widgets/widgets.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptanceButtonsWidget extends StatelessWidget {
  const AcceptanceButtonsWidget({
    Key? key,
    required this.onAcceptancePressed,
    this.agreeTermsAndCondition = false,
    this.readTermsOfUse = false,
  }) : super(key: key);

  final VoidCallback onAcceptancePressed;
  final bool agreeTermsAndCondition;
  final bool readTermsOfUse;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(Sizes.smallRadius),
            bottomRight: Radius.circular(Sizes.smallRadius),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(-1, -1),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(
          Sizes.spaceSmall,
        ),
        margin: const EdgeInsets.only(
          right: Sizes.spaceSmall,
          left: Sizes.spaceSmall,
          bottom: Sizes.spaceSmall,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckboxItem(
              value: agreeTermsAndCondition,
              text: l10n.agreeTermsAndConditionCheckBox,
              onChange: (value) {
                context.read<TOSCubit>().setAgreeTerms(agreeTerms: value);
              },
            ),
            CheckboxItem(
              value: readTermsOfUse,
              text: l10n.readTermsOfUseCheckBox,
              onChange: (value) {
                context.read<TOSCubit>().setReadTerms(readTerms: value);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                padding: const EdgeInsets.symmetric(vertical: 20),
                primary: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: (agreeTermsAndCondition && readTermsOfUse)
                  ? onAcceptancePressed
                  : null,
              child: Text(
                l10n.onBoardingTosButton.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onElevatedButton,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
