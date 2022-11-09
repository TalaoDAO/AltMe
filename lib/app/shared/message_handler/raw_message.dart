import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class RawMessage with MessageHandler {
  RawMessage(this.message);

  final String message;

  @override
  String getMessage(BuildContext context, MessageHandler messageHandler) {
    return message;
  }
}
