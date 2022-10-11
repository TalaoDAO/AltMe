import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AlertMessage {
  static void showStateMessage({
    required BuildContext context,
    required StateMessage stateMessage,
  }) {
    final MessageHandler messageHandler = stateMessage.messageHandler!;
    final String message = messageHandler.getMessage(context, messageHandler);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SnackBarContent(
          message: message,
          iconPath: stateMessage.type!.iconPath,
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static void showStringMessage({
    required BuildContext context,
    required String message,
    required MessageType messageType,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SnackBarContent(
          message: message,
          iconPath: messageType.iconPath,
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    Key? key,
    required this.message,
    required this.iconPath,
  }) : super(key: key);

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
              style: Theme.of(context).textTheme.button?.copyWith(
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
