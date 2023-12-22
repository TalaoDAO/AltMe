import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorageProvider {}

class MockDidCubit extends MockCubit<DIDState> implements DIDCubit {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

void main() {
  late SecureStorageProvider mockSecureStorage;
  late DIDCubit didCubit;
  late HomeCubit homeCubit;
  late CredentialsCubit credentialsCubit;
  late WalletCubit walletCubit;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    didCubit = MockDidCubit();
    homeCubit = MockHomeCubit();
    credentialsCubit = MockCredentialsCubit();
    walletCubit = MockWalletCubit();
  });

  group('Splash Cubit', () {
    test('initial state is correct', () {
      expect(
        SplashCubit(
          credentialsCubit: credentialsCubit,
          secureStorageProvider: mockSecureStorage,
          didCubit: didCubit,
          homeCubit: homeCubit,
          walletCubit: walletCubit,
          client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
        ).state,
        SplashStatus.init,
      );
    });

    group('initialiseApp', () {
      group('SecureStorageKeys.ssiKey', () {
        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.ssiKey is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.ssiKey is empty''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });
      });

      group('SecureStorageKeys.did', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value('key'));
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.did is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.did is empty''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });
      });

      group('SecureStorageKeys.didMethod', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value('key'));
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value('did'));
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.didMethod is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethod))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.didMethod is empty''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethod))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });
      });

      group('SecureStorageKeys.didMethodName', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value('key'));
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value('did'));
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethod))
              .thenAnswer((_) => Future.value('didMethod'));
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.didMethodName is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethodName))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.didMethodName is empty''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethodName))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });
      });

      group('SecureStorageKeys.isEnterpriseUser', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value('key'));
          when(() => mockSecureStorage.get(SecureStorageKeys.did))
              .thenAnswer((_) => Future.value('did'));
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethod))
              .thenAnswer((_) => Future.value('didMethod'));
          when(() => mockSecureStorage.get(SecureStorageKeys.didMethodName))
              .thenAnswer((_) => Future.value('didMethodName'));
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.isEnterpriseUser is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.walletType))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.isEnterpriseUser is empty''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.walletType))
              .thenAnswer((_) => Future.value(''));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            didCubit: didCubit,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        group('when user is enterprise user', () {
          setUp(() {
            when(
              () => mockSecureStorage.get(SecureStorageKeys.walletType),
            ).thenAnswer((_) => Future.value('true'));
          });

          test(
              '''emits SplashStatus.routeToPassCode when SecureStorageKeys.rsaKeyJson is null''',
              () async {
            when(() => mockSecureStorage.get(SecureStorageKeys.rsaKeyJson))
                .thenAnswer((_) => Future.value(null));

            final SplashCubit splashCubit = SplashCubit(
              credentialsCubit: credentialsCubit,
              secureStorageProvider: mockSecureStorage,
              didCubit: didCubit,
              homeCubit: homeCubit,
              walletCubit: walletCubit,
              client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
            );
            await splashCubit.initialiseApp();

            expect(splashCubit.state, SplashStatus.routeToPassCode);
          });

          test(
              '''emits SplashStatus.routeToPassCode when SecureStorageKeys.rsaKeyJson is empty''',
              () async {
            when(() => mockSecureStorage.get(SecureStorageKeys.rsaKeyJson))
                .thenAnswer((_) => Future.value(''));

            final SplashCubit splashCubit = SplashCubit(
              credentialsCubit: credentialsCubit,
              secureStorageProvider: mockSecureStorage,
              didCubit: didCubit,
              homeCubit: homeCubit,
              walletCubit: walletCubit,
              client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
            );
            await splashCubit.initialiseApp();

            expect(splashCubit.state, SplashStatus.routeToPassCode);
          });

          test(
              '''emits SplashStatus.bypassOnBoarding when we have required values''',
              () async {
            when(() => mockSecureStorage.get(SecureStorageKeys.rsaKeyJson))
                .thenAnswer((_) => Future.value('{"key" : "value"}'));

            final SplashCubit splashCubit = SplashCubit(
              credentialsCubit: credentialsCubit,
              secureStorageProvider: mockSecureStorage,
              didCubit: didCubit,
              homeCubit: homeCubit,
              walletCubit: walletCubit,
              client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
            );
            await splashCubit.initialiseApp();

            expect(splashCubit.state, SplashStatus.routeToPassCode);
          });
        });
      });
    });
  });
}
