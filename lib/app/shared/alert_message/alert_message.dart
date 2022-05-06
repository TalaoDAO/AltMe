import 'package:altme/app/app.dart';
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
        content: Text(message),
        backgroundColor: stateMessage.type!.getColor(context),
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
        content: Text(message),
        backgroundColor: messageType.getColor(context),
      ),
    );
  }
}
