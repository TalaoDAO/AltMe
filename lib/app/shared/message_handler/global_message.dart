import 'package:altme/l10n/l10n.dart';

class GlobalMessage {
  GlobalMessage(this.l10n);

  final AppLocalizations l10n;

  String get NETWORK_ERROR_NOT_IMPLEMENTED => l10n.networkErrorNotImplemented;

  String get NETWORK_ERROR_REQUEST_CANCELLED =>
      l10n.networkErrorRequestCancelled;

  String get NETWORK_ERROR_INTERNAL_SERVER_ERROR =>
      l10n.networkErrorInternalServerError;

  String get NETWORK_ERROR_SERVICE_UNAVAILABLE =>
      l10n.networkErrorServiceUnavailable;

  String get NETWORK_ERROR_METHOD_NOT_ALLOWED =>
      l10n.networkErrorMethodNotAllowed;

  String get NETWORK_ERROR_BAD_REQUEST => l10n.networkErrorBadRequest;

  String get NETWORK_ERROR_UNAUTHORIZED_REQUEST =>
      l10n.networkErrorUnauthorizedRequest;

  String get NETWORK_ERROR_UNEXPECTED_ERROR => l10n.networkErrorUnexpectedError;

  String get NETWORK_ERROR_REQUEST_TIMEOUT => l10n.networkErrorRequestTimeout;

  String get NETWORK_ERROR_NO_INTERNET_CONNECTION =>
      l10n.networkErrorNoInternetConnection;

  String get NETWORK_ERROR_CONFLICT => l10n.networkErrorConflict;

  String get NETWORK_ERROR_SEND_TIMEOUT => l10n.networkErrorSendTimeout;

  String get NETWORK_ERROR_UNABLE_TO_PROCESS =>
      l10n.networkErrorUnableToProcess;

  String get NETWORK_ERROR_NOT_ACCEPTABLE => l10n.networkErrorNotAcceptable;

  String get NETWORK_ERROR_GATEWAY_TIMEOUT => l10n.networkErrorGatewayTimeout;

  String get NETWORK_ERROR_TOO_MANY_REQUESTS =>
      l10n.networkErrorTooManyRequests;

  String get NETWORK_ERROR_UNAUTHENTICATED => l10n.networkErrorUnauthenticated;

  String get NETWORK_ERROR_NOT_FOUND => l10n.networkErrorNotFound;

  String get RESPONSE_STRING_FAILED_TO_LOAD_PROFILE => l10n.failedToLoadProfile;

  String get RESPONSE_STRING_FAILED_TO_SAVE_PROFILE => l10n.failedToSaveProfile;

  String get RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL =>
      l10n.failedToCreateSelfIssuedCredential;

  String get RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL =>
      l10n.failedToVerifySelfIssuedCredential;

  String get RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY =>
      l10n.selfIssuedCreatedSuccessfully;

  String get RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR =>
      l10n.backupCredentialError;

  String get RESPONSE_STRING_BACKUP_CREDENTIAL_PERMISSION_DENIED_MESSAGE =>
      l10n.backupCredentialPermissionDeniedMessage;

  String get RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE =>
      l10n.backupCredentialSuccessMessage;

  String get RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE =>
      l10n.recoveryCredentialJSONFormatErrorMessage;

  String get RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE =>
      l10n.recoveryCredentialAuthErrorMessage;

  String get RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE =>
      l10n.recoveryCredentialDefaultErrorMessage;

  String get RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE =>
      l10n.credentialAddedMessage;

  String get RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE =>
      l10n.credentialDetailEditSuccessMessage;

  String get RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE =>
      l10n.credentialDetailDeleteSuccessMessage;

}
