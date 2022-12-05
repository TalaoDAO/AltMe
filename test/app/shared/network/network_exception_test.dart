// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('NetworkException Test', () {
    group('DioError', () {
      test('return requestCancelled response message is DioErrorType.cancel',
          () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.cancel,
        );
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_REQUEST_CANCELLED);
      });

      test(
          'return requestTimeout response when message is '
          'DioErrorType.connectTimeout', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.connectTimeout,
        );
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT);
      });

      test(
          'return noInternetConnection response when message is '
          'DioErrorType.other', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
        );
        final message = NetworkException.getDioException(error: error);
        expect(
          message.message,
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      });

      test(
          'return receiveTimeout response when message is '
          'DioErrorType.receiveTimeout', () {
        final error = DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.receiveTimeout,
        );
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_SEND_TIMEOUT);
      });

      test(
          'return receiveTimeout response when message is '
          'DioErrorType.sendTimeout', () {
        final error = DioError(
          requestOptions: RequestOptions(
            path: '',
          ),
          type: DioErrorType.sendTimeout,
        );
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_SEND_TIMEOUT);
      });

      test(
          '''return badRequest response when message is DioErrorType.receiveTimeout''',
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_BAD_REQUEST);
      });
    });

    group('StatusCode', () {
      test('return badRequest response when statusCode is 404', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_NOT_FOUND);
      });

      test('return internalServerError response when statusCode is 500', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(
          message.message,
          NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR,
        );
      });

      test('return unauthenticated response when statusCode is 401', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_UNAUTHENTICATED);
      });

      test('return unauthorizedRequest response when statusCode is 403', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(
          message.message,
          NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST,
        );
      });

      test('return requestTimeout response when statusCode is 408', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT);
      });

      test('return getDioException response when statusCode is 409', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_CONFLICT);
      });

      test('return tooManyRequests response when statusCode is 429', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS);
      });

      test('return notImplemented response when statusCode is 501', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED);
      });

      test('return serviceUnavailable response when statusCode is 503', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE);
      });

      test('return gatewayTimeout response when statusCode is 504', () {
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
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT);
      });

      test('return defaultError response when status code is not from our list',
          () {
        final message = NetworkException.handleResponse(410, null);
        expect(message.message, NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
      });
    });

    group('OtherError', () {
      test('returns noInternetConnection when socketException is thrown', () {
        const error = SocketException('response');
        final message = NetworkException.getDioException(error: error);
        expect(
          message.message,
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      });

      test('returns unexpectedError when other errror occurs', () {
        const error = FormatException('response');
        final message = NetworkException.getDioException(error: error);
        expect(message.message, NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
      });

      test(
          '''returns UnableToProcess response if message is "is not a subtype of"''',
          () async {
        final message =
            NetworkException.getDioException(error: 'is not a subtype of');
        expect(message.message, NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS);
      });

      test('return UnexpectedError response if message has untracked response',
          () async {
        final message =
            NetworkException.getDioException(error: 'I am random response');
        expect(message.message, NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR);
      });
    });

    group('getErrorMessage function', () {
      testWidgets(
          'returns NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_NOT_IMPLEMENTED.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_REQUEST_CANCELLED for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_REQUEST_CANCELLED)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_REQUEST_CANCELLED,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_REQUEST_CANCELLED.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_INTERNAL_SERVER_ERROR.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_SERVICE_UNAVAILABLE.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_METHOD_NOT_ALLOWED.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_BAD_REQUEST for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_BAD_REQUEST)',
          (tester) async {
        final MessageHandler messageHandler =
            NetworkException(message: NetworkError.NETWORK_ERROR_BAD_REQUEST);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_BAD_REQUEST.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_UNAUTHORIZED_REQUEST.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_UNEXPECTED_ERROR.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_REQUEST_TIMEOUT.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_CONFLICT for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_CONFLICT)',
          (tester) async {
        final MessageHandler messageHandler =
            NetworkException(message: NetworkError.NETWORK_ERROR_CONFLICT);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_CONFLICT.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_SEND_TIMEOUT for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_SEND_TIMEOUT)',
          (tester) async {
        final MessageHandler messageHandler =
            NetworkException(message: NetworkError.NETWORK_ERROR_SEND_TIMEOUT);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_SEND_TIMEOUT.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_NOT_ACCEPTABLE.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_GATEWAY_TIMEOUT.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_TOO_MANY_REQUESTS.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_UNAUTHENTICATED for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_UNAUTHENTICATED)',
          (tester) async {
        final MessageHandler messageHandler = NetworkException(
          message: NetworkError.NETWORK_ERROR_UNAUTHENTICATED,
        );
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_UNAUTHENTICATED.localise(context),
        );
      });

      testWidgets(
          'returns NetworkError.NETWORK_ERROR_NOT_FOUND for '
          'NetworkException(message: NetworkError.NETWORK_ERROR_NOT_FOUND)',
          (tester) async {
        final MessageHandler messageHandler =
            NetworkException(message: NetworkError.NETWORK_ERROR_NOT_FOUND);
        await tester.pumpApp(Container());
        final BuildContext context = tester.element(find.byType(Container));
        final String text = messageHandler.getMessage(context, messageHandler);
        expect(
          text,
          NetworkError.NETWORK_ERROR_NOT_FOUND.localise(context),
        );
      });
    });
  });
}
