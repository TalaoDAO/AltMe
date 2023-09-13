import 'package:flutter/material.dart';

mixin MessageHandler implements Exception {
  String getMessage(
    BuildContext context,
    MessageHandler messageHandler, {
    String? injectedMessage,
  }) {
    return 'Unknown message';
  }
}
