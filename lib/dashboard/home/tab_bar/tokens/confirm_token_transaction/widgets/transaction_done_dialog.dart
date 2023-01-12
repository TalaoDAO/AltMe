import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionDoneDialog extends StatelessWidget {
  const TransactionDoneDialog._({
    Key? key,
    required this.amountAndSymbol,
    this.transactionHash,
    this.onDoneButtonClick,
    this.onTrasactionHashTap,
  }) : super(key: key);

  final String amountAndSymbol;
  final String? transactionHash;
  final VoidCallback? onDoneButtonClick;
  final VoidCallback? onTrasactionHashTap;

  static Future<void> show({
    required BuildContext context,
    required String amountAndSymbol,
    VoidCallback? onDoneButtonClick,
    String? transactionHash,
    VoidCallback? onTrasactionHashTap,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TransactionDoneDialog._(
        amountAndSymbol: amountAndSymbol,
        onDoneButtonClick: onDoneButtonClick,
        transactionHash: transactionHash,
        onTrasactionHashTap: onTrasactionHashTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceNormal,
        vertical: Sizes.spaceSmall,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Sizes.spaceSmall),
            Image.asset(
              IconStrings.bigCheckCircle,
              height: Sizes.icon4x,
              width: Sizes.icon4x,
            ),
            const SizedBox(height: Sizes.spaceNormal),
            Text(
              '$amountAndSymbol ${l10n.sent.toLowerCase()}',
              style: Theme.of(context).textTheme.defaultDialogTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceSmall),
            Text(
              l10n.transactionDoneDialogDescription,
              style: Theme.of(context).textTheme.defaultDialogBody,
              textAlign: TextAlign.center,
            ),
            if (transactionHash != null) ...[
              const SizedBox(height: Sizes.spaceSmall),
              InkWell(
                onTap: onTrasactionHashTap,
                onLongPress: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: transactionHash,
                    ),
                  );
                  AlertMessage.showStateMessage(
                    context: context,
                    stateMessage: StateMessage.success(
                      stringMessage: l10n.copiedToClipboard,
                    ),
                  );
                },
                child: Text(
                  transactionHash!,
                  style: Theme.of(context).textTheme.defaultDialogBody.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: Sizes.spaceSmall),
            MyElevatedButton(
              text: l10n.done,
              verticalSpacing: 18,
              fontSize: 18,
              borderRadius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pop();
                onDoneButtonClick?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
