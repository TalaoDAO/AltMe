import 'package:altme/app/app.dart';
import 'package:altme/app/shared/alert_message/extension.dart';
import 'package:flutter/material.dart';

class AlertMessage {
  static void openSnackBar({
    required BuildContext context,
    required String message,
    MessageType messageType = MessageType.success,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: messageType.getColor(context),
      ),
    );
  }

  static void openErrorSnackBar({
    required BuildContext context,
    required ErrorHandler errorHandler,
  }) {
    final String message = errorHandler.getErrorMessage(context, errorHandler);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: MessageType.error.getColor(context),
      ),
    );
  }
}
