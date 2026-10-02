import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkException with MessageHandler {
  NetworkException({this.message, this.data, this.headers});

  final NetworkError? message;
  final dynamic data;

  /// Headers of the error response, e.g. a `DPoP-Nonce` challenge.
  final Headers? headers;

  static NetworkException handleResponse(int? statusCode, DioException? error) {
    switch (statusCode) {
      // case 200: //No Error
      // case 201: //No Error
      case 400:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_BAD_REQUEST,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 401:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNAUTHENTICATED,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 403:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 404:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_NOT_FOUND,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 408:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 409:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_CONFLICT,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 410:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_NOT_READY,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 412:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_PRECONDITION_FAILED,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 429:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 500:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 501:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 503:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      case 504:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
      default:
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR,
          data: error?.response?.data,
          headers: error?.response?.headers,
        );
        return networkException;
    }
  }

  static NetworkException getDioException({required dynamic error}) {
    if (error is Exception) {
      NetworkException networkException;
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.cancel:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_REQUEST_CANCELLED,
              data: error.response?.data,
            );
          case DioExceptionType.connectionTimeout:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT,
              data: error.response?.data,
            );
          case DioExceptionType.unknown:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
              data: error.response?.data,
            );
          case DioExceptionType.receiveTimeout:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_SEND_TIMEOUT,
              data: error.response?.data,
            );
          case DioExceptionType.badResponse:
            networkException = handleResponse(
              error.response?.statusCode,
              error,
            );
          case DioExceptionType.sendTimeout:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_SEND_TIMEOUT,
              data: error.response?.data,
            );
          case DioExceptionType.badCertificate:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR,
              data: error.response?.data,
            );
          case DioExceptionType.connectionError:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR,
              data: error.response?.data,
            );
        }
      } else if (error is SocketException) {
        networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      } else {
        networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR,
        );
      }
      return networkException;
    } else {
      if (error.toString().contains('is not a subtype of')) {
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS,
        );
        return networkException;
      } else {
        final networkException = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR,
        );
        return networkException;
      }
    }
  }

  @override
  String getMessage(
    BuildContext context,
    MessageHandler messageHandler, {
    String? injectedMessage,
  }) {
    if (messageHandler is NetworkException && messageHandler.message != null) {
      switch (messageHandler.message!) {
        case NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED:
          final message = NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_REQUEST_CANCELLED:
          final message = NetworkError.NETWORK_ERROR_REQUEST_CANCELLED.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR:
          final message = NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR
              .localise(context);
          return message;
        case NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE:
          final message = NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE
              .localise(context);
          return message;
        case NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED:
          final message = NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED
              .localise(context);
          return message;
        case NetworkError.NETWORK_ERROR_BAD_REQUEST:
          final message = NetworkError.NETWORK_ERROR_BAD_REQUEST.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST:
          final message = NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST
              .localise(context);
          return message;
        case NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR:
          final message = NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT:
          final message = NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION:
          final message = NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION
              .localise(context);
          return message;
        case NetworkError.NETWORK_ERROR_CONFLICT:
          final message = NetworkError.NETWORK_ERROR_CONFLICT.localise(context);
          return message;
        case NetworkError.NETWORK_ERROR_SEND_TIMEOUT:
          final message = NetworkError.NETWORK_ERROR_SEND_TIMEOUT.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS:
          final message = NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE:
          final message = NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT:
          final message = NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS:
          final message = NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_UNAUTHENTICATED:
          final message = NetworkError.NETWORK_ERROR_UNAUTHENTICATED.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_NOT_FOUND:
          final message = NetworkError.NETWORK_ERROR_NOT_FOUND.localise(
            context,
          );
          return message;
        case NetworkError.NETWORK_ERROR_PRECONDITION_FAILED:
          final message = NetworkError.NETWORK_ERROR_PRECONDITION_FAILED
              .localise(context);
          return message;
        case NetworkError.NETWORK_ERROR_NOT_READY:
          final message = NetworkError.NETWORK_ERROR_NOT_READY.localise(
            context,
          );
          return message;
      }
    }
    return '';
  }
}
