import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/network/extension.dart';
import 'package:altme/app/shared/network/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('NetworkException Test', () {
    group('DioError', () {
      test('return requestCancelled message error is DioErrorType.cancel', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.cancel,
        );
        final message = NetworkException.getDioException(error);
        expect(message.message, NetworkError.NETWORK_ERROR_REQUEST_CANCELLED);
      });

      test(
          'return requestTimeout message when error is '
          'DioErrorType.connectTimeout', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.connectTimeout,
        );
        final message = NetworkException.getDioException(error);
        expect(message.message, NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT);
      });

      test(
          'return noInternetConnection message when error is '
          'DioErrorType.other', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
        );
        final message = NetworkException.getDioException(error);
        expect(
          message.message,
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      });

      test(
          'return receiveTimeout message when error is '
          'DioErrorType.receiveTimeout', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.receiveTimeout,
        );
        final message = NetworkException.getDioException(error);
        expect(message.message, NetworkError.NETWORK_ERROR_SEND_TIMEOUT);
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
        expect(message.message, NetworkError.NETWORK_ERROR_SEND_TIMEOUT);
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
        expect(message.message, NetworkError.NETWORK_ERROR_BAD_REQUEST);
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
        expect(message.message, NetworkError.NETWORK_ERROR_NOT_FOUND);
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
        expect(
          message.message,
          NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR,
        );
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
        expect(message.message, NetworkError.NETWORK_ERROR_UNAUTHENTICATED);
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
        expect(
          message.message,
          NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST,
        );
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
        expect(message.message, NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT);
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
        expect(message.message, NetworkError.NETWORK_ERROR_CONFLICT);
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
        expect(message.message, NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS);
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
        expect(message.message, NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED);
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
        expect(message.message, NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE);
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
        expect(message.message, NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT);
      });

      test('return defaultError message when status code is not from our list',
          () {
        final message = NetworkException.handleResponse(410);
        expect(message.message, NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
      });
    });

    group('OtherError', () {
      test('returns noInternetConnection when socketException is thrown', () {
        const error = SocketException('message');
        final message = NetworkException.getDioException(error);
        expect(
          message.message,
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      });

      test('returns unexpectedError when other errror occurs', () {
        const error = FormatException('message');
        final message = NetworkException.getDioException(error);
        expect(message.message, NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
      });

      test('returns UnableToProcess message if error is "is not a subtype of"',
          () async {
        final message = NetworkException.getDioException('is not a subtype of');
        expect(message.message, NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS);
      });

      test('return UnexpectedError message if error has untracked message',
          () async {
        final message = NetworkException.getDioException('I am random message');
        expect(message.message, NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
      });
    });

    group('getErrorMessage function', () {
      testWidgets(
          'returns NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED for '
          'NetworkException(NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_REQUEST_CANCELLED for '
          'NetworkException(NetworkError.NETWORK_ERROR_REQUEST_CANCELLED)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_REQUEST_CANCELLED);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_REQUEST_CANCELLED.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR for '
          'NetworkException(NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE for '
          'NetworkException(NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED for '
          'NetworkException(NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_BAD_REQUEST for '
          'NetworkException(NetworkError.NETWORK_ERROR_BAD_REQUEST)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_BAD_REQUEST);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_BAD_REQUEST.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST for '
          'NetworkException(NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR for '
          'NetworkException(NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT for '
          'NetworkException(NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION for '
          'NetworkException(NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_CONFLICT for '
          'NetworkException(NetworkError.NETWORK_ERROR_CONFLICT)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_CONFLICT);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_CONFLICT.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_SEND_TIMEOUT for '
          'NetworkException(NetworkError.NETWORK_ERROR_SEND_TIMEOUT)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_SEND_TIMEOUT);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_SEND_TIMEOUT.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS for '
          'NetworkException(NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE for '
          'NetworkException(NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT for '
          'NetworkException(NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS for '
          'NetworkException(NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_UNAUTHENTICATED for '
          'NetworkException(NetworkError.NETWORK_ERROR_UNAUTHENTICATED)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_UNAUTHENTICATED);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_UNAUTHENTICATED.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_NOT_FOUND for '
          'NetworkException(NetworkError.NETWORK_ERROR_NOT_FOUND)',
          (tester) async {
        final ErrorHandler errorHandler =
            NetworkException(NetworkError.NETWORK_ERROR_NOT_FOUND);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = errorHandler.getErrorMessage(context, errorHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_NOT_FOUND.localise(context),
        );
      });
    });
  });
}
