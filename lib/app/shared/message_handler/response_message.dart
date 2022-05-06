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
            .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE
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
            .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING:
          return ResponseString
              .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL:
          return ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL
              .localise(context);

        case ResponseString.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED:
          return ResponseString.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER:
          return ResponseString
              .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL:
          return ResponseString
              .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL
              .localise(context);

        case ResponseString.RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID:
          return ResponseString.RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_THIS_QR_CODE_DOSE_NOT_CONTAIN_A_VALID_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_THIS_QR_CODE_DOSE_NOT_CONTAIN_A_VALID_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER:
          return ResponseString
              .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER
              .localise(context);

        case ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY:
          return ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN:
          return ResponseString
              .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_DID:
          return ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_DID
              .localise(context);

        case ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST:
          return ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST
              .localise(context);

        case ResponseString.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY:
          return ResponseString.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY
              .localise(context);

        case ResponseString.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY:
          return ResponseString.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY
              .localise(context);

        case ResponseString.RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY:
          return ResponseString.RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY
              .localise(context);

        case ResponseString.RESPONSE_STRING_DID_KEY_NOT_RESOLVED:
          return ResponseString.RESPONSE_STRING_DID_KEY_NOT_RESOLVED
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY:
          return ResponseString
              .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY
              .localise(context);

        case ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA:
          return ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA
              .localise(context);

        case ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE:
          return ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE:
          return ResponseString.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR:
          return ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR
              .localise(context);
      }
    }
    return '';
  }
}
