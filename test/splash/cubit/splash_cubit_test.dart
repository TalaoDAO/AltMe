import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorageProvider {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {
  @override
  Future<void> emitHasWallet() async {}
}

class MockAltmeChatSupportCubit extends MockCubit<ChatRoomState>
    implements AltmeChatSupportCubit {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {
  @override
  Future<void> loadAllCredentials({
    required BlockchainType blockchainType,
  }) async {}
}

class MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {
  @override
  final state = WalletState(
    cryptoAccount: CryptoAccount(
      data: [
        CryptoAccountData(
          name: '',
          secretKey: '',
          blockchainType: BlockchainType.tezos,
          walletAddress: '',
        ),
      ],
    ),
  );

  @override
  Future<void> createCryptoWallet({
    String? accountName,
    required String mnemonicOrKey,
    required bool isImported,
    required bool isFromOnboarding,
    BlockchainType? blockchainType,
    bool showStatus = true,
    void Function({
      required CryptoAccount cryptoAccount,
      required MessageHandler messageHandler,
    })? onComplete,
  }) async {}
}

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
  @override
  final state = ProfileState(model: ProfileModel.empty());
}

class MockTimer extends Mock implements Timer {}

void main() {
  late SecureStorageProvider mockSecureStorage;
  late HomeCubit homeCubit;
  late CredentialsCubit credentialsCubit;
  late WalletCubit walletCubit;
  late AltmeChatSupportCubit altmeChatSupportCubit;
  late ProfileCubit profileCubit;

  final packageInfo = PackageInfo(
    appName: 'testApp',
    packageName: 'com.example.test',
    version: '1.0.0',
    buildNumber: '1',
  );

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    mockSecureStorage = MockSecureStorage();
    homeCubit = MockHomeCubit();
    credentialsCubit = MockCredentialsCubit();
    walletCubit = MockWalletCubit();
    altmeChatSupportCubit = MockAltmeChatSupportCubit();
    profileCubit = MockProfileCubit();

    when(() => mockSecureStorage.get(SecureStorageKeys.version))
        .thenAnswer((_) async => '1.0.0');
    when(() => mockSecureStorage.get(SecureStorageKeys.buildNumber))
        .thenAnswer((_) async => '1');
    when(() => mockSecureStorage.set(SecureStorageKeys.version, '1.0.0'))
        .thenAnswer((_) async => {});
    when(() => mockSecureStorage.set(SecureStorageKeys.buildNumber, '1'))
        .thenAnswer((_) async => {});
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
          packageInfo: packageInfo,
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
      test('counter increases every 500 milliseconds and stops at 5', () {
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
          packageInfo: packageInfo,
        );
        fakeAsync((async) {
          splashCubit.initialiseApp();
          expect(splashCubit.state.loadedValue, equals(0.0));

          async.elapse(const Duration(milliseconds: 500));
          expect(splashCubit.state.loadedValue, equals(0.1));

          async.elapse(const Duration(milliseconds: 500));
          expect(splashCubit.state.loadedValue, equals(0.2));

          // Continue elapsing time until counter reaches 5
          while (splashCubit.state.loadedValue < 1.0) {
            async.elapse(const Duration(milliseconds: 500));
          }

          // Check final state
          expect(splashCubit.state.loadedValue, equals(1.0));
          expect(splashCubit.state.status, equals(SplashStatus.init));

          async.flushMicrotasks();
        });
      });

      group('Route to routeToPassCode', () {
        test('when ssiKey and ssiMnemonics is  not null', () async {
          when(
            () => mockSecureStorage.get(any()),
          ).thenAnswer((_) => Future.value(null));
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiMnemonic))
              .thenAnswer((_) => Future.value('xyz'));
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiKey))
              .thenAnswer((_) => Future.value('xyz'));

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
            packageInfo: packageInfo,
          );
          fakeAsync((async) {
            splashCubit.initialiseApp();
            // complete timer
            while (splashCubit.state.loadedValue <= 1.0) {
              async.elapse(const Duration(milliseconds: 500));
            }
          });
          expect(splashCubit.state.status, SplashStatus.routeToPassCode);
        });
      });

      group('Route to onboarding', () {
        test('when ssiMnemonic is null', () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiMnemonic))
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
            packageInfo: packageInfo,
          );
          fakeAsync((async) {
            splashCubit.initialiseApp();
            // complete timer
            while (splashCubit.state.loadedValue <= 1.0) {
              async.elapse(const Duration(milliseconds: 500));
            }
            async.flushMicrotasks();
          });
          expect(splashCubit.state.status, SplashStatus.routeToOnboarding);
        });
        test('when ssiKey is null', () async {
          when(() => mockSecureStorage.get(SecureStorageKeys.ssiMnemonic))
              .thenAnswer((_) => Future.value('xyz'));
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
            packageInfo: packageInfo,
          );
          fakeAsync((async) {
            splashCubit.initialiseApp();
            // complete timer
            while (splashCubit.state.loadedValue <= 1.0) {
              async.elapse(const Duration(milliseconds: 500));
            }
            async.flushMicrotasks();
          });
          expect(splashCubit.state.status, SplashStatus.routeToOnboarding);
        });
      });
    });
  });
}
