import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'test_constants.dart';

void main() {
  group('DioClient Class', () {
    // test('can be instantiated', () {
    //   expect(getDioClient(baseUrl: baseUrl), isNotNull);
    // });

    group('interceptors', () {
      final dio = Dio(BaseOptions(baseUrl: baseUrl));
      final dioAdapter = DioAdapter(dio: Dio(BaseOptions(baseUrl: baseUrl)));
      dio.httpClientAdapter = dioAdapter;
      // final interceptor = DioInterceptor(dio: dio);
      //final service = DioClient(baseUrl, dio, interceptors: [interceptor]);

      // test('set interceptors', () {
      //   expect(service.interceptors?.length, greaterThan(0));
      // });
    });

    group('exceptions', () {
      final dio = Dio(BaseOptions(baseUrl: 'http://no.domain.com'));
      final service = DioClient('http://no.domain.com', dio);
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
      final dio = Dio(BaseOptions(baseUrl: baseUrl));
      final dioAdapter = DioAdapter(dio: Dio(BaseOptions(baseUrl: baseUrl)));
      dio.httpClientAdapter = dioAdapter;
      final service = DioClient(baseUrl, dio);

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
      final dio = Dio(BaseOptions(baseUrl: baseUrl));
      final dioAdapter = DioAdapter(dio: Dio(BaseOptions(baseUrl: baseUrl)));
      dio.httpClientAdapter = dioAdapter;
      final service = DioClient(baseUrl, dio);

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
