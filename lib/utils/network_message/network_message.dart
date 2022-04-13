import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:network/network.dart';

class NetworkMessage {
  ///displayError
  void displayError(
    BuildContext context,
    NetworkException error,
    Color errorColor,
  ) {
    final errorMessage = getErrorMessage(context, error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: errorColor,
        content: Text(errorMessage),
      ),
    );
  }

  ///getErrorMessage
  String getErrorMessage(
    BuildContext context,
    NetworkException networkException,
  ) {
    final l10n = context.l10n;

    var errorMessage = '';
    networkException.when(
      notImplemented: () {
        errorMessage = l10n.networkErrorNotImplemented;
      },
      requestCancelled: () {
        errorMessage = l10n.networkErrorRequestCancelled;
      },
      internalServerError: () {
        errorMessage = l10n.networkErrorInternalServerError;
      },
      notFound: (String reason) {
        errorMessage = reason;
      },
      serviceUnavailable: () {
        errorMessage = l10n.networkErrorServiceUnavailable;
      },
      methodNotAllowed: () {
        errorMessage = l10n.networkErrorMethodNotAllowed;
      },
      badRequest: () {
        errorMessage = l10n.networkErrorBadRequest;
      },
      unauthorizedRequest: () {
        errorMessage = l10n.networkErrorUnauthorizedRequest;
      },
      unexpectedError: () {
        errorMessage = l10n.networkErrorUnexpectedError;
      },
      requestTimeout: () {
        errorMessage = l10n.networkErrorRequestTimeout;
      },
      noInternetConnection: () {
        errorMessage = l10n.networkErrorNoInternetConnection;
      },
      conflict: () {
        errorMessage = l10n.networkErrorConflict;
      },
      sendTimeout: () {
        errorMessage = l10n.networkErrorSendTimeout;
      },
      unableToProcess: () {
        errorMessage = l10n.networkErrorUnableToProcess;
      },
      defaultError: (String error) {
        errorMessage = error;
      },
      formatException: () {
        errorMessage = l10n.networkErrorUnexpectedError;
      },
      notAcceptable: () {
        errorMessage = l10n.networkErrorNotAcceptable;
      },
      created: () {
        errorMessage = l10n.networkErrorCreated;
      },
      gatewayTimeout: () {
        errorMessage = l10n.networkErrorGatewayTimeout;
      },
      ok: () {
        errorMessage = l10n.networkErrorOk;
      },
      tooManyRequests: () {
        errorMessage = l10n.networkErrorTooManyRequests;
      },
      unauthenticated: () {
        errorMessage = l10n.networkErrorUnauthenticated;
      },
    );
    return errorMessage;
  }
}
