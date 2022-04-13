import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:test/test.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  const key = 'key';
  const value = 'value';
  const allValue = <String, String>{};

  late MockFlutterSecureStorage mockFlutterSecureStorage;

  late SecureStorageProvider secureStorageProvider;

  setUpAll(() async {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    secureStorageProvider = SecureStorageProvider(mockFlutterSecureStorage);
  });

  group('SecureStorage', () {
    test('can be instantiated', () {
      expect(getSecureStorage, isNotNull);
    });

    test('get method works correctly', () async {
      when(() => mockFlutterSecureStorage.read(key: key))
          .thenAnswer((invocation) async {
        return value;
      });
      final result = await secureStorageProvider.get(key);
      expect(result, equals(value));
      verify(() => mockFlutterSecureStorage.read(key: key)).called(1);
    });

    test('getAll method works correctly', () async {
      when(
        () => mockFlutterSecureStorage.readAll(
          iOptions: any(named: 'iOptions'),
        ),
      ).thenAnswer((invocation) async {
        return allValue;
      });
      final result = await secureStorageProvider.getAllValues();
      expect(result, equals(allValue));
      verify(
        () => mockFlutterSecureStorage.readAll(
          iOptions: any(named: 'iOptions'),
        ),
      ).called(1);
    });

    test('set method works correctly', () async {
      when(
        () => mockFlutterSecureStorage.write(
          key: key,
          value: value,
          iOptions: any(named: 'iOptions'),
        ),
      ).thenAnswer((invocation) async {});

      await secureStorageProvider.set(key, value);

      verify(
        () => mockFlutterSecureStorage.write(
          key: key,
          value: value,
          iOptions: any(named: 'iOptions'),
        ),
      ).called(1);
    });

    test('delete method works correctly', () async {
      when(
        () => mockFlutterSecureStorage.delete(
          key: key,
          iOptions: any(named: 'iOptions'),
        ),
      ).thenAnswer((_) async {});

      await secureStorageProvider.delete(
        key,
      );
      verify(
        () => mockFlutterSecureStorage.delete(
          key: key,
          iOptions: any(named: 'iOptions'),
        ),
      ).called(1);
    });

    test('deleteAll method works correctly', () async {
      when(mockFlutterSecureStorage.deleteAll)
          .thenAnswer((invocation) async {});

      await secureStorageProvider.deleteAll();
      verify(mockFlutterSecureStorage.deleteAll).called(1);
    });
  });
}
