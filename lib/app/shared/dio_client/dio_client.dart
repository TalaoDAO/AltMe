import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:secure_storage/secure_storage.dart';
part 'logging.dart';

const _defaultConnectTimeout = Duration(minutes: 1);
const _defaultReceiveTimeout = Duration(minutes: 1);

class DioClient {
  DioClient({
    this.baseUrl,
    required this.secureStorageProvider,
    required this.dio,
  }) {
    if (baseUrl != null) {
      dio.options.baseUrl = baseUrl!;
    }

    dio
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..interceptors.add(Logging());

    // if (kDebugMode) {
    //   _dio.interceptors.add(
    //     LogInterceptor(
    //       responseBody: true,
    //       requestHeader: false,
    //       responseHeader: false,
    //       request: false,
    //     ),
    //   );
    // }
  }

  final log = getLogger('DioClient');

  final SecureStorageProvider secureStorageProvider;
  final Dio dio;
  String? baseUrl;

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic> headers = const <String, dynamic>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    bool isCachingEnabled = false,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final requestOptions = await _requestOptions(uri, headers, options);
      log.i('uri - $uri');
      dynamic response;

      if (isCachingEnabled) {
        final cachedData = await secureStorageProvider.get(uri);
        if (cachedData == null) {
          response = await dio.get<dynamic>(
            uri,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          );
        } else {
          final cachedDataJson = jsonDecode(cachedData);
          final expiry = int.parse(cachedDataJson['expiry'].toString());

          final isExpired = DateTime.now().millisecondsSinceEpoch > expiry;
          if (isExpired) {
            response = await dio.get<dynamic>(
              uri,
              queryParameters: queryParameters,
              options: requestOptions,
              cancelToken: cancelToken,
              onReceiveProgress: onReceiveProgress,
            );
          } else {
            /// directly return cached data
            /// returned here to avoid the caching override everytime
            final response = await cachedDataJson['data'];
            return response;
          }
        }
      } else {
        response = await dio.get<dynamic>(
          uri,
          queryParameters: queryParameters,
          options: requestOptions,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
      }

      log.i('Time - ${stopwatch.elapsed}');
      return response.data;
    } on FormatException catch (_) {
      throw ResponseMessage(
        message: ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA,
      );
    } catch (e) {
      if (e is DioException) {
        throw NetworkException.getDioException(error: e);
      } else {
        rethrow;
      }
    }
  }

  /// [options] carrying the headers of a request to [uri].
  ///
  /// Set on the request, never on `dio.options`: this Dio is shared, and
  /// defaults set by one request (a PAR's client attestation and DPoP proof)
  /// would be sent with every later one, verifiers included.
  Future<Options> _requestOptions(
    String uri,
    Map<String, dynamic> headers,
    Options? options,
  ) async {
    var requestHeaders = headers;
    if (uri.contains(Urls.tezotopiaMembershipCardUrl) ||
        uri.contains(Urls.chainbornMembershipCardUrl) ||
        uri.contains(Urls.twitterCardUrl)) {
      await dotenv.load();
      final YOTI_AI_API_KEY = dotenv.get('YOTI_AI_API_KEY');

      requestHeaders = <String, dynamic>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'X-API-KEY': YOTI_AI_API_KEY,
      };
    }
    final requestOptions = (options ?? Options()).copyWith(
      headers: {...requestHeaders, ...?options?.headers},
    );
    return requestOptions;
  }

  Future<dynamic> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic> headers = const <String, dynamic>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    int? timeout,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final requestOptions = await _requestOptions(uri, headers, options);
      if (timeout != null) {
        dio.options.connectTimeout = Duration(seconds: timeout);
        dio.options.receiveTimeout = Duration(seconds: timeout);
      }
      final response = await dio.post<dynamic>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      log.i('Time - ${stopwatch.elapsed}');
      resetTimeout(timeout);
      return response.data;
    } on FormatException catch (_) {
      resetTimeout(timeout);
      throw ResponseMessage(
        message: ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA,
      );
    } catch (e) {
      resetTimeout(timeout);
      if (e is DioException) {
        throw NetworkException.getDioException(error: e);
      } else {
        rethrow;
      }
    }
  }

  @visibleForTesting
  void resetTimeout(int? timeout) {
    if (timeout == null) return;
    dio.options.connectTimeout = _defaultConnectTimeout;
    dio.options.receiveTimeout = _defaultReceiveTimeout;
  }
}
