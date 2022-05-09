import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ImportWalletButton extends StatelessWidget {
  const ImportWalletButton({Key? key, this.onPressed}) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeHelper.buttonHeightLarge,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeHelper.radiusNormal),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.15),
          ),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(
          context.l10n.importWallet,
          style: Theme.of(context)
              .textTheme
              .button
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
