import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class AddAccountPopUp extends StatefulWidget {
  const AddAccountPopUp({Key? key, this.defaultAccountName}) : super(key: key);

  final String? defaultAccountName;

  @override
  State<AddAccountPopUp> createState() => _AddAccountPopUpState();
}

class _AddAccountPopUpState extends State<AddAccountPopUp> {
  late TextEditingController controller =
      TextEditingController(text: widget.defaultAccountName);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 0.3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.cryptoAddAccount,
                    style: Theme.of(context).textTheme.dialogTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: Sizes.spaceSmall,
                  ),
                  Text(
                    l10n.enterNameForYourNewAccount,
                    style: Theme.of(context).textTheme.dialogSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              RawMaterialButton(
                onPressed: () => Navigator.of(context).pop(),
                fillColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.all(2),
                shape: const CircleBorder(),
                elevation: 5,
                constraints: const BoxConstraints(
                  maxWidth: Sizes.icon2x,
                  maxHeight: Sizes.icon2x,
                ),
                child: const Icon(
                  Icons.close,
                  size: Sizes.icon,
                  color: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(height: Sizes.spaceNormal),
          BaseTextField(
            label: l10n.accountName,
            controller: controller,
            borderRadius: Sizes.smallRadius,
            textCapitalization: TextCapitalization.sentences,
            fillColor: Theme.of(context).highlightColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: Sizes.spaceSmall,
              horizontal: Sizes.spaceSmall,
            ),
            borderColor: Theme.of(context).colorScheme.onInverseSurface,
          ),
          const SizedBox(height: 24),
          MyElevatedButton(
            text: l10n.create,
            verticalSpacing: Sizes.normalRadius,
            elevation: 10,
            borderRadius: Sizes.smallRadius,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.label,
            fontSize: 15,
            onPressed: () {
              // TODO(Taleb): Navigate to create account page with account name
            },
          ),
          const SizedBox(width: Sizes.spaceNormal),
          MyOutlinedButton(
            text: l10n.import,
            verticalSpacing: Sizes.smallRadius,
            fontSize: 12,
            elevation: 0,
            borderColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            textColor: Theme.of(context).colorScheme.label,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push<void>(OnBoardingRecoveryPage.route());
            },
          ),
        ],
      ),
    );
  }
}
