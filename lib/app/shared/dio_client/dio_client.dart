import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioClient {
  DioClient(
    this.baseUrl,
    this._dio, {
    this.interceptors,
  }) {
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.headers = <String, dynamic>{
        'Content-Type': 'application/json; charset=UTF-8'
      };
    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
        ),
      );
    }
  }

  final String baseUrl;
  final Dio _dio;
  final List<Interceptor>? interceptors;

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA,
      );
    } catch (e) {
      if (e is DioError) {
        throw NetworkException.getDioException(e);
      } else {
        rethrow;
      }
    }
  }

  Future<dynamic> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA,
      );
    } catch (e) {
      if (e is DioError) {
        throw NetworkException.getDioException(e);
      } else {
        rethrow;
      }
    }
  }

  void changeHeaders(Map<String, dynamic> headers) =>
      _dio.options.headers = headers;
}
