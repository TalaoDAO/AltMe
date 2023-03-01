import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
part 'logging.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioClient {
  DioClient(this.baseUrl, this._dio) {
    _dio
      ..options.baseUrl = baseUrl
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

  final String baseUrl;
  final Dio _dio;

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic> headers = const <String, dynamic>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
  }) async {
    try {
      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      final stopwatch = Stopwatch()..start();
      await getSpecificHeader(uri, headers);
      final response = await _dio.get<dynamic>(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      log.i('Time - ${stopwatch.elapsed}');
      return response.data;
    } on FormatException catch (_) {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA,
      );
    } catch (e) {
      if (e is DioError) {
        throw NetworkException.getDioException(error: e);
      } else {
        rethrow;
      }
    }
  }

  Future<void> getSpecificHeader(
    String uri,
    Map<String, dynamic> headers,
  ) async {
    if (uri.contains(Urls.tezotopiaMembershipCardUrl) ||
        uri.contains(Urls.bloometaCardUrl) ||
        uri.contains(Urls.chainbornMembershipCardUrl) ||
        uri.contains(Urls.twitterCardUrl)) {
      await dotenv.load();
      final YOTI_AI_API_KEY = dotenv.get('YOTI_AI_API_KEY');

      _dio.options.headers = <String, dynamic>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'X-API-KEY': YOTI_AI_API_KEY,
      };
    } else {
      _dio.options.headers = headers;
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
    Map<String, dynamic> headers = const <String, dynamic>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
  }) async {
    try {
      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      final stopwatch = Stopwatch()..start();
      await getSpecificHeader(uri, headers);
      final response = await _dio.post<dynamic>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      log.i('Time - ${stopwatch.elapsed}');
      return response.data;
    } on FormatException catch (_) {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA,
      );
    } catch (e) {
      if (e is DioError) {
        throw NetworkException.getDioException(error: e);
      } else {
        rethrow;
      }
    }
  }
}
