import 'package:altme/l10n/l10n.dart';

class ResponseMessage {
  ResponseMessage(this.l10n);

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

  String get MESSAGE_ERROR_FAILED_TO_LOAD_PROFILE => l10n.failedToLoadProfile;

  String get MESSAGE_ERROR_FAILED_TO_SAVE_PROFILE => l10n.failedToSaveProfile;
}
