part of 'dio_client.dart';

class Logging extends Interceptor {
  final log = getLogger('Response');

  String _encode(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // One message per part: logcat cuts a message at about 4 KB, and a single
    // client attestation header nearly fills that, which used to cut off the
    // remaining headers and the body.
    log.i('REQUEST[${options.method}] => PATH: ${options.uri}');
    for (final header in options.headers.entries) {
      log.i('Header ${header.key}: ${header.value}');
    }
    if (options.queryParameters.isNotEmpty) {
      log.i('Query: ${_encode(options.queryParameters)}');
    }
    log.i('Body: ${_encode(options.data)}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log.i(
      '''RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} => data: ${jsonEncode(response.data)}''',
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // The headers a client acts on after a refusal: the authentication
    // challenge and a server-issued DPoP nonce (RFC 9449 §8, §9).
    final challengeHeaders = {
      for (final name in const ['www-authenticate', 'dpop-nonce'])
        if (err.response?.headers.value(name) case final value?) name: value,
    };
    final headers = challengeHeaders.isEmpty
        ? ''
        : ' headers: ${_encode(challengeHeaders)}';
    log.e(
      'ERROR[${err.response?.statusCode}] TYPE[${err.type}],=> PATH:'
      ' ${err.requestOptions.path} data: ${_encode(err.response?.data)}'
      '$headers',
    );
    return super.onError(err, handler);
  }
}
