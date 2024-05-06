import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorageProvider {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockAltmeChatSupportCubit extends MockCubit<ChatRoomState>
    implements AltmeChatSupportCubit {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  late SecureStorageProvider mockSecureStorage;
  late HomeCubit homeCubit;
  late CredentialsCubit credentialsCubit;
  late WalletCubit walletCubit;
  late AltmeChatSupportCubit altmeChatSupportCubit;
  late ProfileCubit profileCubit;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    mockSecureStorage = MockSecureStorage();
    homeCubit = MockHomeCubit();
    credentialsCubit = MockCredentialsCubit();
    walletCubit = MockWalletCubit();
    altmeChatSupportCubit = MockAltmeChatSupportCubit();
    profileCubit = MockProfileCubit();
  });

  group('Splash Cubit', () {
    test('initial state is correct', () {
      expect(
        SplashCubit(
          credentialsCubit: credentialsCubit,
          secureStorageProvider: mockSecureStorage,
          homeCubit: homeCubit,
          walletCubit: walletCubit,
          client: DioClient(
            baseUrl: Urls.checkIssuerTalaoUrl,
            secureStorageProvider: mockSecureStorage,
            dio: Dio(),
          ),
          altmeChatSupportCubit: altmeChatSupportCubit,
          profileCubit: profileCubit,
        ).state,
        const SplashState(
          status: SplashStatus.init,
          versionNumber: '',
          buildNumber: '',
          isNewVersion: false,
          loadedValue: 0,
        ),
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
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
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
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
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
          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.did is empty''',
            () async {
          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });
      });

      group('SecureStorageKeys.didMethod', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value('key'));
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.didMethod is null''',
            () async {
          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.didMethod is empty''',
            () async {
          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });
      });

      group('SecureStorageKeys.didMethodName', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value('key'));
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.didMethodName is null''',
            () async {
          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.didMethodName is empty''',
            () async {
          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
          );
          await splashCubit.initialiseApp();

          expect(splashCubit.state, SplashStatus.routeToPassCode);
        });
      });

      group('SecureStorageKeys.isEnterpriseUser', () {
        setUp(() {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value('key'));
        });

        test(
            '''emits SplashStatus.routeToPassCode when SecureStorageKeys.isEnterpriseUser is null''',
            () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.walletType))
              .thenAnswer((_) => Future.value(null));

          final SplashCubit splashCubit = SplashCubit(
            credentialsCubit: credentialsCubit,
            secureStorageProvider: mockSecureStorage,
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
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
            homeCubit: homeCubit,
            walletCubit: walletCubit,
            client: DioClient(
              baseUrl: Urls.checkIssuerTalaoUrl,
              secureStorageProvider: mockSecureStorage,
              dio: Dio(),
            ),
            altmeChatSupportCubit: altmeChatSupportCubit,
            profileCubit: profileCubit,
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
              homeCubit: homeCubit,
              walletCubit: walletCubit,
              client: DioClient(
                baseUrl: Urls.checkIssuerTalaoUrl,
                secureStorageProvider: mockSecureStorage,
                dio: Dio(),
              ),
              altmeChatSupportCubit: altmeChatSupportCubit,
              profileCubit: profileCubit,
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
              homeCubit: homeCubit,
              walletCubit: walletCubit,
              client: DioClient(
                baseUrl: Urls.checkIssuerTalaoUrl,
                secureStorageProvider: mockSecureStorage,
                dio: Dio(),
              ),
              altmeChatSupportCubit: altmeChatSupportCubit,
              profileCubit: profileCubit,
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
              homeCubit: homeCubit,
              walletCubit: walletCubit,
              client: DioClient(
                baseUrl: Urls.checkIssuerTalaoUrl,
                secureStorageProvider: mockSecureStorage,
                dio: Dio(),
              ),
              altmeChatSupportCubit: altmeChatSupportCubit,
              profileCubit: profileCubit,
            );
            await splashCubit.initialiseApp();

            expect(splashCubit.state, SplashStatus.routeToPassCode);
          });
        });
      });
    });
  });
}
