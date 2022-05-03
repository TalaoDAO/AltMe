import 'package:altme/app/app.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorageProvider {}

void main() {
  late SecureStorageProvider mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
  });

  group('Splash Cubit', () {
    test('initial state is correct', () {
      expect(SplashCubit(mockSecureStorage).state, SplashStatus.init);
    });

    group('initialiseApp', () {
      group('SecureStorageKeys.key', () {
        test('emits SplashStatus.onboarding when SecureStorageKeys.key is null',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.key))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });

        test(
            'emits SplashStatus.onboarding when SecureStorageKeys.key is empty',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.key))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });
      });

      group('SecureStorageKeys.did', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.key))
              .thenAnswer((_) => Future.value('key'));
        });

        test('emits SplashStatus.onboarding when SecureStorageKeys.did is null',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });

        test(
            'emits SplashStatus.onboarding when SecureStorageKeys.did is empty',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });
      });

      group('SecureStorageKeys.didMethod', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.key))
              .thenAnswer((_) => Future.value('key'));
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value('did'));
        });

        test(
            '''emits SplashStatus.onboarding when SecureStorageKeys.didMethod is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethod))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });

        test(
            '''emits SplashStatus.onboarding when SecureStorageKeys.didMethod is empty''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethod))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });
      });

      group('SecureStorageKeys.didMethodName', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.key))
              .thenAnswer((_) => Future.value('key'));
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value('did'));
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethod))
              .thenAnswer((_) => Future.value('didMethod'));
        });

        test(
            '''emits SplashStatus.onboarding when SecureStorageKeys.didMethodName is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethodName))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });

        test(
            '''emits SplashStatus.onboarding when SecureStorageKeys.didMethodName is empty''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethodName))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });
      });

      group('SecureStorageKeys.isEnterpriseUser', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.key))
              .thenAnswer((_) => Future.value('key'));
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value('did'));
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethod))
              .thenAnswer((_) => Future.value('didMethod'));
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethodName))
              .thenAnswer((_) => Future.value('didMethodName'));
        });

        test(
            '''emits SplashStatus.onboarding when SecureStorageKeys.isEnterpriseUser is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.isEnterpriseUser))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });

        test(
            '''emits SplashStatus.onboarding when SecureStorageKeys.isEnterpriseUser is empty''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.isEnterpriseUser))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.onboarding);
        });

        group('when user is enterprise user', () {
          setUp(() {
            when(
              () => mockSecureStorage.get(SecureStorageKeys.isEnterpriseUser),
            ).thenAnswer((_) => Future.value('true'));
          });

          test(
              '''emits SplashStatus.onboarding when SecureStorageKeys.rsaKeyJson is null''',
              () async {
            when(() => mockSecureStorage.get(SecureStorageKeys.rsaKeyJson))
                .thenAnswer((_) => Future.value(null));

            final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
            await splashCubit.initialiseApp();

            expect(splashCubit.state, SplashStatus.onboarding);
          });

          test(
              '''emits SplashStatus.onboarding when SecureStorageKeys.rsaKeyJson is empty''',
              () async {
            when(() => mockSecureStorage.get(SecureStorageKeys.rsaKeyJson))
                .thenAnswer((_) => Future.value(''));

            final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
            await splashCubit.initialiseApp();

            expect(splashCubit.state, SplashStatus.onboarding);
          });

          test(
              '''emits SplashStatus.bypassOnboarding when we have required values''',
              () async {
            when(() => mockSecureStorage.get(SecureStorageKeys.rsaKeyJson))
                .thenAnswer((_) => Future.value('{"key" : "value"}'));

            final SplashCubit splashCubit = SplashCubit(mockSecureStorage);
            await splashCubit.initialiseApp();

            expect(splashCubit.state, SplashStatus.bypassOnboarding);
          });
        });
      });
    });
  });
}
