import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  group('NetworkException Test', () {
    group('DioError', () {
      test('return requestCancelled message error is DioErrorType.cancel', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.cancel,
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.requestCancelled());
      });

      test(
          'return requestTimeout message when error is '
          'DioErrorType.connectTimeout', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.connectTimeout,
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.requestTimeout());
      });

      test(
          'return noInternetConnection message when error is '
          'DioErrorType.other', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.noInternetConnection());
      });

      test(
          'return receiveTimeout message when error is '
          'DioErrorType.receiveTimeout', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.receiveTimeout,
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.sendTimeout());
      });

      test(
          'return receiveTimeout message when error is '
          'DioErrorType.sendTimeout', () {
        final error = DioError(
          requestOptions: RequestOptions(
            path: '',
          ),
          type: DioErrorType.sendTimeout,
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.sendTimeout());
      });

      test(
          'return badRequest message when error is DioErrorType.receiveTimeout',
          () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 400,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.badRequest());
      });
    });

    group('StatusCode', () {
      test('return badRequest message when statusCode is 404', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 404,
          ),
        );
        final message = NetworkException.getDioException(error);
        // TODO(bibash): localise
        expect(message, const NetworkException.notFound('Not found'));
      });

      test('return internalServerError message when statusCode is 500', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 500,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.internalServerError());
      });

      test('return unauthenticated message when statusCode is 401', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 401,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.unauthenticated());
      });

      test('return unauthorizedRequest message when statusCode is 403', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 403,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.unauthorizedRequest());
      });

      test('return requestTimeout message when statusCode is 408', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 408,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.requestTimeout());
      });

      test('return getDioException message when statusCode is 409', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 409,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.conflict());
      });

      test('return tooManyRequests message when statusCode is 429', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 429,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.tooManyRequests());
      });

      test('return notImplemented message when statusCode is 501', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 501,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.notImplemented());
      });

      test('return serviceUnavailable message when statusCode is 503', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 503,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.serviceUnavailable());
      });

      test('return gatewayTimeout message when statusCode is 504', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.response,
          response: Response<dynamic>(
            requestOptions: RequestOptions(
              path: '',
            ),
            statusCode: 504,
          ),
        );
        final message = NetworkException.getDioException(error);
        expect(message, const NetworkException.gatewayTimeout());
      });

      test('return defaultError message when status code is not from our list',
          () {
        final message = NetworkException.handleResponse(410);
        expect(
          message,
          const NetworkException.defaultError(
            'Received invalid status code: 410',
          ),
        );
      });
    });

    group('OtherError', () {
      test('returns noInternetConnection when socketException is thrown', () {
        const error = SocketException('message');
        final message = NetworkException.getDioException(error);
        expect(
          message,
          const NetworkException.noInternetConnection(),
        );
      });

      test('returns unexpectedError when DefaultError is thrown', () {
        const error = DefaultError('');
        final message = NetworkException.getDioException(error);
        expect(
          message,
          const NetworkException.unexpectedError(),
        );
      });

      test('returns UnableToProcess message if error is "is not a subtype of"',
          () async {
        final message = NetworkException.getDioException('is not a subtype of');
        expect(message, const NetworkException.unableToProcess());
      });

      test('return UnexpectedError message if error has untracked message',
          () async {
        final message = NetworkException.getDioException('I am random message');
        expect(message, const NetworkException.unexpectedError());
      });
    });
  });
}
