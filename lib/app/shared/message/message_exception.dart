import 'package:altme/app/app.dart';
import 'package:altme/app/shared/message/extension.dart';
import 'package:flutter/material.dart';

class MessageException with ErrorHandler {
  MessageException(this.message);

  final MessageError message;

  @override
  String getErrorMessage(BuildContext context, ErrorHandler errorHandler) {
    if (errorHandler is MessageException) {
      switch (errorHandler.message) {
        case MessageError.MESSAGE_ERROR_FAILED_TO_LOAD_PROFILE:
          return MessageError.MESSAGE_ERROR_FAILED_TO_LOAD_PROFILE
              .localise(context);
        case MessageError.MESSAGE_ERROR_FAILED_TO_SAVE_PROFILE:
          return MessageError.MESSAGE_ERROR_FAILED_TO_SAVE_PROFILE
              .localise(context);
      }
    }
    return '';
  }
}
