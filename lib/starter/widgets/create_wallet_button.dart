import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CreateWalletButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CreateWalletButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeHelper.buttonHeightLarge,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Theme.of(context).primaryButtonGradient,
        borderRadius: BorderRadius.circular(SizeHelper.radiusNormal),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeHelper.radiusNormal),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(
          context.l10n.createWallet,
          style: Theme.of(context)
              .textTheme
              .button
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
