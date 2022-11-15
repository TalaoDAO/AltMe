import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class AddAccountPopUp extends StatefulWidget {
  const AddAccountPopUp({
    Key? key,
    this.defaultAccountName,
    required this.onCreateAccount,
    required this.onImportAccount,
  }) : super(key: key);

  final String? defaultAccountName;
  final Function(String) onImportAccount;
  final Function(String) onCreateAccount;

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
          MyGradientButton(
            text: l10n.create,
            verticalSpacing: 10,
            borderRadius: 10,
            elevation: 10,
            onPressed: () => widget.onCreateAccount.call(controller.text),
          ),
          const SizedBox(height: Sizes.spaceXSmall),
          MyOutlinedButton(
            text: l10n.import,
            verticalSpacing: Sizes.smallRadius,
            fontSize: 17,
            elevation: 0,
            borderColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            textColor: Theme.of(context).colorScheme.label,
            onPressed: () => widget.onImportAccount.call(controller.text),
          ),
        ],
      ),
    );
  }
}
