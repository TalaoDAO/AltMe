import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  test('Exception Dio Cancel', () {
    final error = DioError(
      requestOptions: RequestOptions(path: ''),
      type: DioErrorType.cancel,
    );
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.requestCancelled());
  });

  test('Exception Connection Timeout', () {
    final error = DioError(
      requestOptions: RequestOptions(path: ''),
      type: DioErrorType.connectTimeout,
    );
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.requestTimeout());
  });

  test('Exception other', () {
    final error = DioError(
      requestOptions: RequestOptions(path: ''),
    );
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.noInternetConnection());
  });

  test('Exception Receive Timeout', () {
    final error = DioError(
      requestOptions: RequestOptions(path: ''),
      type: DioErrorType.receiveTimeout,
    );
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.sendTimeout());
  });

  test('Exception Response 400', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.badRequest());
  });

  test('Exception Response 404', () {
    final error = DioError(
      requestOptions: RequestOptions(path: ''),
      type: DioErrorType.response,
      response: Response<dynamic>(
          requestOptions: RequestOptions(
            path: '',
          ),
          statusCode: 404,),
    );
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.notFound('Not found'));
  });

  test('Exception Response 500', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.internalServerError());
  });

  test('Exception Response 401', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.unauthenticated());
  });

  test('Exception Response 403', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.unauthorizedRequest());
  });

  test('Exception Response 408', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.requestTimeout());
  });

  test('Exception Response 409', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.conflict());
  });

  test('Exception Response 429', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.tooManyRequests());
  });

  test('Exception Response 501', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.notImplemented());
  });

  test('Exception Response 503', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.serviceUnavailable());
  });

  test('Exception Response 504', () {
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
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.gatewayTimeout());
  });

  test('Exception Send Timeout', () {
    final error = DioError(
      requestOptions: RequestOptions(
        path: '',
      ),
      type: DioErrorType.sendTimeout,
    );
    final exception = NetworkException.getDioException(error);
    expect(exception, const NetworkException.sendTimeout());
  });
}
