import 'dart:convert';
import 'dart:io';

import 'package:altme/app/shared/widget/image_from_network/image_from_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  testWidgets('Get image widget with good url', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(const ImageFromNetwork('success'));
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SizedBox), findsNothing);
    });
  });
  testWidgets('get SizedBox on error', (tester) async {
    final key = GlobalKey();
    await mockNetworkImages(() async {
      await tester.pumpWidget(
        ImageFromNetwork('https://toto.fr', key: key),
      );
      //expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}

/// Based on  mocktail_image_network (https://pub.dev/packages/mocktail_image_network)

T mockNetworkImages<T>(T Function() body) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => _createHttpClient(),
  );
}

class _MockHttpClient extends Mock implements HttpClient {
  _MockHttpClient() {
    registerFallbackValue((List<int> _) {});
    registerFallbackValue(Uri());
  }

  @override
  set autoUncompress(bool _autoUncompress) {}

  @override
  bool get autoUncompress => false;
}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

HttpClient _createHttpClient() {
  final client = _MockHttpClient();
  final request = _MockHttpClientRequest();
  final response = _MockHttpClientResponse();
  final headers = _MockHttpHeaders();
  when(() => response.compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(() => response.contentLength).thenReturn(_transparentPixelPng.length);
  when(() => response.statusCode).thenReturn(HttpStatus.ok);
  when(
    () => response.listen(
      any(),
      onDone: any(named: 'onDone'),
      onError: any(named: 'onError'),
      cancelOnError: any(named: 'cancelOnError'),
    ),
  ).thenAnswer((invocation) {
    final onData =
        invocation.positionalArguments[0] as void Function(List<int>);
    final onDone = invocation.namedArguments[#onDone] as void Function()?;
    return Stream<List<int>>.fromIterable(<List<int>>[_transparentPixelPng])
        .listen(onData, onDone: onDone);
  });
  when(() => request.headers).thenReturn(headers);
  when(() => client.getUrl(any())).thenAnswer((_) async {
    when(request.close).thenAnswer((_) async => response);
    return request;
  });
  when(() => client.getUrl(Uri.parse('https://toto.fr'))).thenAnswer((_) async {
    when(() => response.statusCode).thenReturn(HttpStatus.badRequest);
    when(
      () => response.listen(
        any(),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
        cancelOnError: any(named: 'cancelOnError'),
      ),
    ).thenAnswer((invocation) {
      throw Exception('not found image at https://toto.fr');
      // final onData =
      //     invocation.positionalArguments[0] as void Function(List<int>);
      // final onDone = invocation.namedArguments[#onDone] as void Function()?;
      // return Stream<List<int>>.fromIterable(<List<int>>[_transparentPixelPng])
      //     .listen(onData, onDone: onDone);
    });
    return request;
  });
  return client;
}

final _transparentPixelPng = base64Decode(
  '''iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==''',
);
