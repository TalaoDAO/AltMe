import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class _MockOidc4vc extends Mock implements OIDC4VCIClient {}

class _MockSecureStorage extends Mock implements SecureStorageProvider {}

void main() {
  const requestUri = 'https://verifier.example.com/request/1';

  late _MockOidc4vc oidc4vc;
  late DioClient client;

  setUp(() {
    forgetRequestObjects();
    oidc4vc = _MockOidc4vc();
    client = DioClient(secureStorageProvider: _MockSecureStorage(), dio: Dio());
    registerFallbackValue(Dio());
  });

  void answer(Future<String> Function() fetch) => when(
    () => oidc4vc.fetchRequestObject(
      requestUri: any(named: 'requestUri'),
      dio: any(named: 'dio'),
      requestUriMethod: any(named: 'requestUriMethod'),
      walletMetadata: any(named: 'walletMetadata'),
    ),
  ).thenAnswer((_) => fetch());

  Future<dynamic> fetch() => fetchRequestUriPayload(
    url: requestUri,
    client: client,
    oidc4vc: oidc4vc,
    requestUriMethod: 'post',
  );

  int fetches() => verify(
    () => oidc4vc.fetchRequestObject(
      requestUri: requestUri,
      dio: any(named: 'dio'),
      requestUriMethod: 'post',
      walletMetadata: any(named: 'walletMetadata'),
    ),
  ).callCount;

  group('fetchRequestUriPayload', () {
    test('fetches a request_uri once per request', () async {
      answer(() async => 'request.object.jwt');

      final results = [await fetch(), await fetch(), await fetch()];

      expect(results, everyElement('request.object.jwt'));
      expect(fetches(), 1);
    });

    test('shares a fetch still in progress', () async {
      answer(() async => 'request.object.jwt');

      await Future.wait([fetch(), fetch()]);

      expect(fetches(), 1);
    });

    test('fetches again after a failure', () async {
      answer(() async => throw DioException(requestOptions: RequestOptions()));
      expect(await fetch(), '');

      answer(() async => 'request.object.jwt');
      expect(await fetch(), 'request.object.jwt');
    });

    test('fetches again for a new request', () async {
      answer(() async => 'request.object.jwt');
      await fetch();

      forgetRequestObjects();
      await fetch();

      expect(fetches(), 2);
    });
  });
}
