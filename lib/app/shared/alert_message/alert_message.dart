import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AlertMessage {
  static void showStateMessage({
    required BuildContext context,
    required StateMessage stateMessage,
  }) {
    final MessageHandler? messageHandler = stateMessage.messageHandler;
    final String? stringMessage = stateMessage.stringMessage;
    String message = '';

    if (messageHandler != null) {
      message = messageHandler.getMessage(context, messageHandler);
    }

    if (stringMessage != null) {
      if (message.isNotEmpty) {
        message = '$message $stringMessage';
      } else {
        message = stringMessage;
      }
    }

    if (stateMessage.showDialog) {
      showDialog<bool>(
        context: context,
        builder: (context) => InfoDialog(
          title: message,
          button: context.l10n.ok,
          //icon: stateMessage.type.iconPath,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 800),
          content: SnackBarContent(
            message: message,
            iconPath: stateMessage.type.iconPath,
          ),
          backgroundColor: Colors.transparent,
        ),
      );
    }
  }
}

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    super.key,
    required this.message,
    required this.iconPath,
  });

  final String message;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.space2XSmall,
        horizontal: Sizes.spaceXSmall,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.smallRadius),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
            child: Image.asset(
              iconPath,
              width: Sizes.icon,
              height: Sizes.icon,
            ),
          ),
          Expanded(
            child: MyText(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                  ),
              maxLines: 2,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Text(
              l10n.close.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
