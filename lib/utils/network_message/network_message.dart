import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:network/network.dart';

class NetworkMessage {
  ///getErrorMessage
  String getErrorMessage(
      BuildContext context, NetworkException networkException) {
    final localizations = AppLocalizations.of(context);

    var errorMessage = '';
    networkException.when(notImplemented: () {
      errorMessage = localizations.networkErrorNotImplemented;
    }, requestCancelled: () {
      errorMessage = localizations.networkErrorRequestCancelled;
    }, internalServerError: () {
      errorMessage = localizations.networkErrorInternalServerError;
    }, notFound: (String reason) {
      errorMessage = reason;
    }, serviceUnavailable: () {
      errorMessage = localizations.networkErrorServiceUnavailable;
    }, methodNotAllowed: () {
      errorMessage = localizations.networkErrorMethodNotAllowed;
    }, badRequest: () {
      errorMessage = localizations.networkErrorBadRequest;
    }, unauthorizedRequest: () {
      errorMessage = localizations.networkErrorUnauthorizedRequest;
    }, unexpectedError: () {
      errorMessage = localizations.networkErrorUnexpectedError;
    }, requestTimeout: () {
      errorMessage = localizations.networkErrorRequestTimeout;
    }, noInternetConnection: () {
      errorMessage = localizations.networkErrorNoInternetConnection;
    }, conflict: () {
      errorMessage = localizations.networkErrorConflict;
    }, sendTimeout: () {
      errorMessage = localizations.networkErrorSendTimeout;
    }, unableToProcess: () {
      errorMessage = localizations.networkErrorUnableToProcess;
    }, defaultError: (String error) {
      errorMessage = error;
    }, formatException: () {
      errorMessage = localizations.networkErrorUnexpectedError;
    }, notAcceptable: () {
      errorMessage = localizations.networkErrorNotAcceptable;
    }, created: () {
      errorMessage = localizations.networkErrorCreated;
    }, gatewayTimeout: () {
      errorMessage = localizations.networkErrorGatewayTimeout;
    }, ok: () {
      errorMessage = localizations.networkErrorOk;
    }, tooManyRequests: () {
      errorMessage = localizations.networkErrorTooManyRequests;
    }, unauthenticated: () {
      errorMessage = localizations.networkErrorUnauthenticated;
    });
    return errorMessage;
  }

  ///displayError
  void displayError(
      BuildContext context, NetworkException error, Color errorColor) {
    final errorMessage = getErrorMessage(context, error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: errorColor,
        content: Text(errorMessage),
      ),
    );
  }
}
