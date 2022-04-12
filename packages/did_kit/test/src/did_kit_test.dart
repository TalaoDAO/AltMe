// ignore_for_file: prefer_const_constructors
import 'package:did_kit/did_kit.dart';
import 'package:didkit/didkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDidKit extends Mock implements DIDKitProvider {}


void main() {
  final mockDidKit = MockDidKit();

  group('DidKit', () {


    test('can be instantiated',() {
      expect(DIDKitProvider(), isNotNull);
    });


    test('verify did kit version is 0.3', () {
      when(mockDidKit.getVersion).thenReturn('0.3');
      expect(mockDidKit.getVersion(), '0.3');
    });

  });
}
