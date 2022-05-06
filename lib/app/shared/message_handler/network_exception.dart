import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkException with MessageHandler {
  NetworkException(this.message);

  final NetworkError message;

  static NetworkException handleResponse(int? statusCode) {
    switch (statusCode) {
      // case 200: //No Error
      // case 201: //No Error
      case 400:
        return NetworkException(NetworkError.NETWORK_ERROR_BAD_REQUEST);
      case 401:
        return NetworkException(NetworkError.NETWORK_ERROR_UNAUTHENTICATED);
      case 403:
        return NetworkException(
          NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST,
        );
      case 404:
        return NetworkException(NetworkError.NETWORK_ERROR_NOT_FOUND);
      case 408:
        return NetworkException(NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT);
      case 409:
        return NetworkException(NetworkError.NETWORK_ERROR_CONFLICT);
      case 429:
        return NetworkException(NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS);
      case 500:
        return NetworkException(
          NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR,
        );
      case 501:
        return NetworkException(NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED);
      case 503:
        return NetworkException(NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE);
      case 504:
        return NetworkException(NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT);
      default:
        return NetworkException(NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
    }
  }

  static NetworkException getDioException(dynamic error) {
    if (error is Exception) {
      NetworkException networkException;
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.cancel:
            networkException =
                NetworkException(NetworkError.NETWORK_ERROR_REQUEST_CANCELLED);
            break;
          case DioErrorType.connectTimeout:
            networkException =
                NetworkException(NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT);
            break;
          case DioErrorType.other:
            networkException = NetworkException(
              NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
            );
            break;
          case DioErrorType.receiveTimeout:
            networkException =
                NetworkException(NetworkError.NETWORK_ERROR_SEND_TIMEOUT);
            break;
          case DioErrorType.response:
            networkException = handleResponse(error.response?.statusCode);
            break;
          case DioErrorType.sendTimeout:
            networkException =
                NetworkException(NetworkError.NETWORK_ERROR_SEND_TIMEOUT);
            break;
        }
      } else if (error is SocketException) {
        networkException =
            NetworkException(NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION);
      } else {
        networkException =
            NetworkException(NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
      }
      return networkException;
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return NetworkException(NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS);
      } else {
        return NetworkException(NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
      }
    }
  }

  @override
  String getMessage(BuildContext context, MessageHandler messageHandler) {
    if (messageHandler is NetworkException) {
      switch (messageHandler.message) {
        case NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED:
          return NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED.localise(context);
        case NetworkError.NETWORK_ERROR_REQUEST_CANCELLED:
          return NetworkError.NETWORK_ERROR_REQUEST_CANCELLED.localise(context);
        case NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR:
          return NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR
              .localise(context);
        case NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE:
          return NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE
              .localise(context);
        case NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED:
          return NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED
              .localise(context);
        case NetworkError.NETWORK_ERROR_BAD_REQUEST:
          return NetworkError.NETWORK_ERROR_BAD_REQUEST.localise(context);
        case NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST:
          return NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST
              .localise(context);
        case NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR:
          return NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR.localise(context);
        case NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT:
          return NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT.localise(context);
        case NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION:
          return NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION
              .localise(context);
        case NetworkError.NETWORK_ERROR_CONFLICT:
          return NetworkError.NETWORK_ERROR_CONFLICT.localise(context);
        case NetworkError.NETWORK_ERROR_SEND_TIMEOUT:
          return NetworkError.NETWORK_ERROR_SEND_TIMEOUT.localise(context);
        case NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS:
          return NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS.localise(context);
        case NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE:
          return NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE.localise(context);
        case NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT:
          return NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT.localise(context);
        case NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS:
          return NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS.localise(context);
        case NetworkError.NETWORK_ERROR_UNAUTHENTICATED:
          return NetworkError.NETWORK_ERROR_UNAUTHENTICATED.localise(context);
        case NetworkError.NETWORK_ERROR_NOT_FOUND:
          return NetworkError.NETWORK_ERROR_NOT_FOUND.localise(context);
      }
    }
    return '';
  }
}
