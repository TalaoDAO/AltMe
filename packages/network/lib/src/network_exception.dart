import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exception.freezed.dart';

///NetworkException
@freezed
class NetworkException with Exception, _$NetworkException {
  const NetworkException._();

  ///badRequest
  const factory NetworkException.badRequest() = BadRequest;

  ///conflict
  const factory NetworkException.conflict() = Conflict;

  ///created
  const factory NetworkException.created() = Created;

  ///defaultError
  const factory NetworkException.defaultError(String error) = DefaultError;

  ///formatException
  const factory NetworkException.formatException() = NetworkFormatException;

  ///gatewayTimeout
  const factory NetworkException.gatewayTimeout() = GatewayTimeout;

  ///internalServerError
  const factory NetworkException.internalServerError() = InternalServerError;

  ///methodNotAllowed
  const factory NetworkException.methodNotAllowed() = MethodNotAllowed;

  ///noInternetConnection
  const factory NetworkException.noInternetConnection() = NoInternetConnection;

  ///notAcceptable
  const factory NetworkException.notAcceptable() = NotAcceptable;

  ///notFound
  const factory NetworkException.notFound(String reason) = NotFound;

  ///notImplemented
  const factory NetworkException.notImplemented() = NotImplemented;

  ///ok
  const factory NetworkException.ok() = Ok;

  ///requestCancelled
  const factory NetworkException.requestCancelled() = RequestCancelled;

  ///requestTimeout
  const factory NetworkException.requestTimeout() = RequestTimeout;

  ///sendTimeout
  const factory NetworkException.sendTimeout() = SendTimeout;

  ///serviceUnavailable
  const factory NetworkException.serviceUnavailable() = ServiceUnavailable;

  ///tooManyRequests
  const factory NetworkException.tooManyRequests() = TooManyRequests;

  ///unableToProcess
  const factory NetworkException.unableToProcess() = UnableToProcess;

  ///unauthenticated
  const factory NetworkException.unauthenticated() = Unauthenticated;

  ///unauthorizedRequest
  const factory NetworkException.unauthorizedRequest() = UnauthorizedRequest;

  ///unexpectedError
  const factory NetworkException.unexpectedError() = UnexpectedError;

  ///handleResponse
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
        return NetworkException.defaultError(
          'Received invalid status code: $responseCode',
        );
    }
  }

  ///getDioException
  factory NetworkException.getDioException(dynamic error) {
    if (error is Exception) {
      try {
        NetworkException networkException;
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
      } on FormatException catch (_) {
        return const NetworkException.formatException();
      } catch (_) {
        return const NetworkException.unexpectedError();
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return const NetworkException.unableToProcess();
      } else {
        return const NetworkException.unexpectedError();
      }
    }
  }
}
