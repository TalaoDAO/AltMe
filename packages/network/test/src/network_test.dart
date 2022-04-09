import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:network/network.dart';

import 'test_constants.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
  });

  group('Network class methods test', () {
    group('Get Method', () {
      test('Get Method Success test', () async {
        dioAdapter.onGet(
          testPath,
          (request) {
            return request.reply(200, successMessage);
          },
          queryParameters: <String, dynamic>{},
          headers: <String, dynamic>{},
        );

        final service = Network(
          baseUrl,
          dio,
        );

        final dynamic response = await service.get(testPath);

        expect(response, successMessage);
      });
    });

    group('Post Method', () {
      test('Post Method Success test', () async {
        dioAdapter.onPost(
          testPath,
          (request) {
            return request.reply(201, successMessage);
          },
          data: json.encode(testData),
          queryParameters: <String, dynamic>{},
          headers: header,
        );

        final service = Network(
          baseUrl,
          dio,
        );

        final dynamic response = await service.post(
          testPath,
          data: json.encode(testData),
          options: Options(headers: header),
        );

        expect(response, successMessage);
      });
    });
  });
}
