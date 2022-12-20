import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkException with MessageHandler {
  NetworkException({required this.message, this.data});

  final NetworkError message;
  final dynamic data;

  static NetworkException handleResponse(int? statusCode, DioError? error) {
    switch (statusCode) {
      // case 200: //No Error
      // case 201: //No Error
      case 400:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_BAD_REQUEST,
          data: error?.response?.data,
        );
      case 401:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_UNAUTHENTICATED,
          data: error?.response?.data,
        );
      case 403:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST,
          data: error?.response?.data,
        );
      case 404:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_NOT_FOUND,
          data: error?.response?.data,
        );
      case 408:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT,
          data: error?.response?.data,
        );
      case 409:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_CONFLICT,
          data: error?.response?.data,
        );
      case 412:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_PRECONDITION_FAILED,
          data: error?.response?.data,
        );
      case 429:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS,
          data: error?.response?.data,
        );
      case 500:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR,
          data: error?.response?.data,
        );
      case 501:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED,
          data: error?.response?.data,
        );
      case 503:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE,
          data: error?.response?.data,
        );
      case 504:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT,
          data: error?.response?.data,
        );
      default:
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR,
          data: error?.response?.data,
        );
    }
  }

  static NetworkException getDioException({
    required dynamic error,
  }) {
    if (error is Exception) {
      NetworkException networkException;
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.cancel:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_REQUEST_CANCELLED,
              data: error.response?.data,
            );
            break;
          case DioErrorType.connectTimeout:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT,
              data: error.response?.data,
            );
            break;
          case DioErrorType.other:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
              data: error.response?.data,
            );
            break;
          case DioErrorType.receiveTimeout:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_SEND_TIMEOUT,
              data: error.response?.data,
            );
            break;
          case DioErrorType.response:
            networkException = handleResponse(
              error.response?.statusCode,
              error,
            );
            break;
          case DioErrorType.sendTimeout:
            networkException = NetworkException(
              message: NetworkError.NETWORK_ERROR_SEND_TIMEOUT,
              data: error.response?.data,
            );
            break;
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
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS,
        );
      } else {
        return NetworkException(
          message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR,
        );
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
        case NetworkError.NETWORK_ERROR_PRECONDITION_FAILED:
          return NetworkError.NETWORK_ERROR_PRECONDITION_FAILED
              .localise(context);
      }
    }
    return '';
  }
}
