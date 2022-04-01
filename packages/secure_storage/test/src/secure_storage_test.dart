// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:test/test.dart';

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

void main() {
  const key = 'key';
  const value = 'value';
  const key1 = 'key1';
  const value1 = 'value1';

  final SecureStorageProvider secureStorageProvider =
      MockSecureStorageProvider();

  setUp(() async {
    when(secureStorageProvider.deleteAll).thenAnswer((invocation) async {});
    await secureStorageProvider.deleteAll();
  });

  group('SecureStorage', () {
    test('can be instantiated', () {
      expect(secureStorageProvider, isNotNull);
    });

    test('set method', () async {
      when(
        () => secureStorageProvider.set(key, value),
      ).thenAnswer((invocation) async {});

      await secureStorageProvider.set(key, value);

      when(
        () => secureStorageProvider.get(key),
      ).thenAnswer((invocation) => Future.value(value));

      final result = await secureStorageProvider.get(key);
      expect(result, equals(value));
    });

    test('delete method', () async {
      when(() => secureStorageProvider.set(key, value))
          .thenAnswer((invocation) async {});

      when(() => secureStorageProvider.delete(key))
          .thenAnswer((invocation) async {});

      when(() => secureStorageProvider.get(key))
          .thenAnswer((invocation) => Future.value(null));

      await secureStorageProvider.set(key, value);
      await secureStorageProvider.delete(key);
      final result = await secureStorageProvider.get(key);
      expect(result, isNull);
    });

    test('deleteAll method', () async {
      when(() => secureStorageProvider.set(key, value))
          .thenAnswer((invocation) async {});
      when(() => secureStorageProvider.set(key1, value1))
          .thenAnswer((invocation) async {});

      await secureStorageProvider.set(key, value);
      await secureStorageProvider.set(key1, value1);

      when(secureStorageProvider.deleteAll).thenAnswer((invocation) async {});
      when(secureStorageProvider.getAllValues)
          .thenAnswer((invocation) => Future.value(<String, dynamic>{}));

      await secureStorageProvider.deleteAll();
      final result = await secureStorageProvider.getAllValues();
      expect(result, equals(<String,dynamic>{}));
    });

  });
}
