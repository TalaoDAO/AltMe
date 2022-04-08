import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:network/src/network_exception.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

///DioClient
class Network {
  ///DioClient
  Network(
    this.baseUrl,
    Dio? dio, {
    this.interceptors,
  }) : _dio = dio ?? Dio() {
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
            request: false),
      );
    }
  }

  ///baseUrl
  final String baseUrl;

  final Dio _dio;

  ///interceptors
  final List<Interceptor>? interceptors;

  ///get
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<Response<dynamic>>(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      if (e is DioError) {
        throw NetworkException.getDioException(e);
      } else {
        rethrow;
      }
    }
  }

  ///post
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
      final response = await _dio.post<Response<dynamic>>(
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
      throw const FormatException('Unable to process the data');
    } catch (e) {
      if (e is DioError) {
        throw NetworkException.getDioException(e);
      } else {
        rethrow;
      }
    }
  }

  ///changeHeaders
  set headers(Map<String, dynamic> headers) =>
    _dio.options.headers = headers;


  ///headers
  Map<String, dynamic> get headers => _dio.options.headers;

}
