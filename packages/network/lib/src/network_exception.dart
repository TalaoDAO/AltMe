import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exception.freezed.dart';

@freezed
class NetworkException with Exception, _$NetworkException {
  const NetworkException._();

  const factory NetworkException.badRequest() = BadRequest;

  const factory NetworkException.conflict() = Conflict;

  const factory NetworkException.created() = Created;

  const factory NetworkException.defaultError(String error) = DefaultError;

  const factory NetworkException.formatException() = NetworkFormatException;

  const factory NetworkException.gatewayTimeout() = GatewayTimeout;

  const factory NetworkException.internalServerError() = InternalServerError;

  const factory NetworkException.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkException.noInternetConnection() = NoInternetConnection;

  const factory NetworkException.notAcceptable() = NotAcceptable;

  const factory NetworkException.notFound(String reason) = NotFound;

  const factory NetworkException.notImplemented() = NotImplemented;

  const factory NetworkException.ok() = Ok;

  const factory NetworkException.requestCancelled() = RequestCancelled;

  const factory NetworkException.requestTimeout() = RequestTimeout;

  const factory NetworkException.sendTimeout() = SendTimeout;

  const factory NetworkException.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkException.tooManyRequests() = TooManyRequests;

  const factory NetworkException.unableToProcess() = UnableToProcess;

  const factory NetworkException.unauthenticated() = Unauthenticated;

  const factory NetworkException.unauthorizedRequest() = UnauthorizedRequest;

  const factory NetworkException.unexpectedError() = UnexpectedError;

  factory NetworkException.handleResponse(int? statusCode) {
    switch (statusCode) {
      case 200:
        return const NetworkException.ok();
      case 201:
        return const NetworkException.created();
      case 400:
        return const NetworkException.badRequest();
      case 401:
        return const NetworkException.unauthenticated();
      case 403:
        return const NetworkException.unauthorizedRequest();
      case 404:
        return const NetworkException.notFound('Not found');
      case 408:
        return const NetworkException.requestTimeout();
      case 409:
        return const NetworkException.conflict();
      case 429:
        return const NetworkException.tooManyRequests();
      case 500:
        return const NetworkException.internalServerError();
      case 501:
        return const NetworkException.notImplemented();
      case 503:
        return const NetworkException.serviceUnavailable();
      case 504:
        return const NetworkException.gatewayTimeout();
      default:
        final responseCode = statusCode;
        // TODO(bibash): localise
        return NetworkException.defaultError(
          'Received invalid status code: $responseCode',
        );
    }
  }

  factory NetworkException.getDioException(dynamic error) {
    if (error is Exception) {
      late NetworkException networkException;
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.cancel:
            networkException = const NetworkException.requestCancelled();
            break;
          case DioErrorType.connectTimeout:
            networkException = const NetworkException.requestTimeout();
            break;
          case DioErrorType.other:
            networkException = const NetworkException.noInternetConnection();
            break;
          case DioErrorType.receiveTimeout:
            networkException = const NetworkException.sendTimeout();
            break;
          case DioErrorType.response:
            networkException =
                NetworkException.handleResponse(error.response?.statusCode);
            break;
          case DioErrorType.sendTimeout:
            networkException = const NetworkException.sendTimeout();
            break;
        }
      } else if (error is SocketException) {
        networkException = const NetworkException.noInternetConnection();
      } else {
        networkException = const NetworkException.unexpectedError();
      }
      return networkException;
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return const NetworkException.unableToProcess();
      } else {
        return const NetworkException.unexpectedError();
      }
    }
  }
}
