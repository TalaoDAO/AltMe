import 'package:dio/dio.dart';
import 'package:secure_storage/secure_storage.dart';

Future<dynamic> dioGet(
  String uri, {
  required Dio dio,
  Map<String, dynamic> headers = const <String, dynamic>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  bool isCachingEnabled = false,
  SecureStorageProvider? secureStorage,
}) async {
  try {
    final secureStorageProvider = secureStorage ?? getSecureStorage;
    // final cachedData = await secureStorageProvider.get(uri);
    // TODO(hawkbee): To be removed.
    /// temporary solution to purge faulty stored data
    /// Will be removed in the future
    await secureStorageProvider.delete(uri);

    /// end of temporary solution
    dynamic response;

    dio.options.headers = headers;

    // if (isCachingEnabled) {
    //   final secureStorageProvider = getSecureStorage;
    //   final cachedData = await secureStorageProvider.get(uri);
    //   if (cachedData == null) {
    //     response = await dio.get<dynamic>(uri);
    //   } else {
    //     final cachedDataJson = jsonDecode(cachedData);
    //     final expiry = int.parse(cachedDataJson['expiry'].toString());

    //     final isExpired = DateTime.now().millisecondsSinceEpoch > expiry;

    //     if (isExpired) {
    //       response = await dio.get<dynamic>(uri);
    //     } else {
    //       /// directly return cached data
    //       /// returned here to avoid the caching override everytime
    //       final response = await cachedDataJson['data'];
    //       return response;
    //     }
    //   }
    // }
    // temporary deactiviting this caching du to issue with
    // flutter_secure_storage on ios #2657
    // final expiry =
    //     DateTime.now().add(const Duration(days: 2)).millisecondsSinceEpoch;

    // final value = {'expiry': expiry, 'data': response.data};
    // await secureStorageProvider.set(uri, jsonEncode(value));
    response = await dio.get<dynamic>(
      uri,
      options: Options().copyWith(
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // ignore: avoid_dynamic_calls
    return response.data;
  } on FormatException {
    throw Exception();
  } catch (e) {
    if (e is DioException) {
      throw Exception();
    } else {
      rethrow;
    }
  }
}
