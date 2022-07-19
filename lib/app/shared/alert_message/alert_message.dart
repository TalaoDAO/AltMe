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
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          margin: const EdgeInsets.all(Sizes.spaceXSmall),
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.space2XSmall,
            horizontal: Sizes.spaceXSmall,
          ),
          decoration: BoxDecoration(
            color: stateMessage.type!.getColor(context),
            borderRadius: const BorderRadius.all(
              Radius.circular(Sizes.smallRadius),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: MyText(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  l10n.close.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
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
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          margin: const EdgeInsets.all(Sizes.spaceXSmall),
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.space2XSmall,
            horizontal: Sizes.spaceXSmall,
          ),
          decoration: BoxDecoration(
            color: messageType.getColor(context),
            borderRadius: const BorderRadius.all(
              Radius.circular(Sizes.smallRadius),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: MyText(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  l10n.close.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
