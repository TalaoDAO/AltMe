part of 'network_error.dart';

extension NetworkErrorX on NetworkError {
  String localise(BuildContext context) {
    final GlobalMessage globalMessage = GlobalMessage(context.l10n);
    switch (this) {
      case NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED:
        return globalMessage.NETWORK_ERROR_NOT_IMPLEMENTED;
      case NetworkError.NETWORK_ERROR_REQUEST_CANCELLED:
        return globalMessage.NETWORK_ERROR_REQUEST_CANCELLED;
      case NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR:
        return globalMessage.NETWORK_ERROR_INTERNAL_SERVER_ERROR;
      case NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE:
        return globalMessage.NETWORK_ERROR_SERVICE_UNAVAILABLE;
      case NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED:
        return globalMessage.NETWORK_ERROR_METHOD_NOT_ALLOWED;
      case NetworkError.NETWORK_ERROR_BAD_REQUEST:
        return globalMessage.NETWORK_ERROR_BAD_REQUEST;
      case NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST:
        return globalMessage.NETWORK_ERROR_UNAUTHORIZED_REQUEST;
      case NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR:
        return globalMessage.NETWORK_ERROR_UNEXPECTED_ERROR;
      case NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT:
        return globalMessage.NETWORK_ERROR_REQUEST_TIMEOUT;
      case NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION:
        return globalMessage.NETWORK_ERROR_NO_INTERNET_CONNECTION;
      case NetworkError.NETWORK_ERROR_CONFLICT:
        return globalMessage.NETWORK_ERROR_CONFLICT;
      case NetworkError.NETWORK_ERROR_SEND_TIMEOUT:
        return globalMessage.NETWORK_ERROR_SEND_TIMEOUT;
      case NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS:
        return globalMessage.NETWORK_ERROR_UNABLE_TO_PROCESS;
      case NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE:
        return globalMessage.NETWORK_ERROR_NOT_ACCEPTABLE;
      case NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT:
        return globalMessage.NETWORK_ERROR_GATEWAY_TIMEOUT;
      case NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS:
        return globalMessage.NETWORK_ERROR_TOO_MANY_REQUESTS;
      case NetworkError.NETWORK_ERROR_UNAUTHENTICATED:
        return globalMessage.NETWORK_ERROR_UNAUTHENTICATED;
      case NetworkError.NETWORK_ERROR_NOT_FOUND:
        return globalMessage.NETWORK_ERROR_NOT_FOUND;
    }
  }
}
