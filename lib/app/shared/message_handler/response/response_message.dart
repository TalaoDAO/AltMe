import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class ResponseMessage with MessageHandler {
  ResponseMessage(this.message);

  final ResponseString message;

  @override
  String getMessage(BuildContext context, MessageHandler messageHandler) {
    if (messageHandler is ResponseMessage) {
      switch (messageHandler.message) {
        case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE:
          return ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE:
          return ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL:
          return ResponseString
              .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL:
          return ResponseString
              .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL
              .localise(context);

        case ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY:
          return ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY
              .localise(context);

        case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR:
          return ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_BACKUP_CREDENTIAL_PERMISSION_DENIED_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_BACKUP_CREDENTIAL_PERMISSION_DENIED_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE:
          return ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE
              .localise(context);
      }
    }
    return '';
  }
}
