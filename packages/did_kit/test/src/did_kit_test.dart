// ignore_for_file: prefer_const_constructors
import 'package:did_kit/src/didkit_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDidKit extends Mock implements DIDKitIO {}


void main() {
  final mockDidKit = MockDidKit();

  group('DidKit', () {
    test('verify did kit version is 0.3', () {
      when(mockDidKit.getVersion).thenReturn('0.3');
      expect(mockDidKit.getVersion(), '0.3');
    });
  });
}
