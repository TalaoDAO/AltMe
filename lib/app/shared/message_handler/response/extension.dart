import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';

extension MessageErrorExtension on ResponseString {
  String localise(BuildContext context) {
    final GlobalMessage globalMessage = GlobalMessage(context.l10n);
    switch (this) {
      case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE:
        return globalMessage.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE;

      case ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE:
        return globalMessage.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE;

      case ResponseString
          .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL:
        return globalMessage
            .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL;

      case ResponseString
          .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL:
        return globalMessage
            .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL;

      case ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY:
        return globalMessage.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY;

      case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR:
        return globalMessage.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR;

      case ResponseString
          .RESPONSE_STRING_BACKUP_CREDENTIAL_PERMISSION_DENIED_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_BACKUP_CREDENTIAL_PERMISSION_DENIED_MESSAGE;

      case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE:
        return globalMessage.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE;

      case ResponseString
          .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE;

      case ResponseString
          .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE;

      case ResponseString
          .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE;

      case ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE:
        return globalMessage.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE;

      case ResponseString
          .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE;

      case ResponseString
          .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE;
    }
  }
}
