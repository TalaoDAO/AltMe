import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';

extension MessageErrorExtension on MessageError {
  String localise(BuildContext context) {
    final ResponseMessage responseMessage = ResponseMessage(context.l10n);
    switch (this) {
      case MessageError.MESSAGE_ERROR_FAILED_TO_LOAD_PROFILE:
        return responseMessage.MESSAGE_ERROR_FAILED_TO_LOAD_PROFILE;
      case MessageError.MESSAGE_ERROR_FAILED_TO_SAVE_PROFILE:
        return responseMessage.MESSAGE_ERROR_FAILED_TO_SAVE_PROFILE;
    }
  }
}
