import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

import 'test_constants.dart';

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockSecureStorageProvider mockSecureStorageProvider;

  final client = Dio();

  late DioAdapter dioAdapter;
  late DioClient service;

  setUp(() {
    dioAdapter =
        DioAdapter(dio: Dio(BaseOptions()), matcher: const UrlRequestMatcher());
    client.httpClientAdapter = dioAdapter;
    mockSecureStorageProvider = MockSecureStorageProvider();
    service = DioClient(
      baseUrl: baseUrl,
      secureStorageProvider: mockSecureStorageProvider,
      dio: client,
    );
  });

  group('DioClient Class', () {
    test('can be instantiated', () {
      expect(service, isNotNull);
    });

    test('set interceptors', () {
      expect(service.dio.interceptors.length, greaterThan(0));
    });

    group('exceptions', () {
      test('socket exception in get method', () async {
        try {
          await service.get('/path');
        } catch (e) {
          if (e is NetworkException) {
            expect(
              e.message,
              NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
            );
          }
        }
      });

      test('socket exception in post method', () async {
        try {
          await service.post('/path');
        } catch (e) {
          if (e is NetworkException) {
            expect(
              e.message,
              NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
            );
          }
        }
      });
    });

    group('Get Method', () {
      test('Get Method Success test', () async {
        dioAdapter.onGet(
          baseUrl + testPath,
          (request) {
            return request.reply(200, successMessage);
          },
        );

        final dynamic response = await service.get(baseUrl + testPath);

        expect(response, successMessage);
      });
    });

    group('Post Method', () {
      test('Post Method Success test', () async {
        dioAdapter.onPost(
          baseUrl + testPath,
          (request) {
            return request.reply(201, successMessage);
          },
          data: json.encode(testData),
          queryParameters: <String, dynamic>{},
          headers: header,
        );

        final dynamic response = await service.post(
          baseUrl + testPath,
          data: json.encode(testData),
          options: Options(headers: header),
        );

        expect(response, successMessage);
      });
    });
  });
}
