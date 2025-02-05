import 'dart:convert';

import 'package:altme/activity_log/activity_log_manager.dart';
import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/lang/lang.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

import '../../../helpers/helpers.dart';

class MockDIDKitProvider extends Mock implements DIDKitProvider {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {
  @override
  Future<void> emitHasWallet() async {}
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
    required QRCodeScanCubit qrCodeScanCubit,
    required CredentialsCubit credentialsCubit,
    required WalletConnectCubit walletConnectCubit,
    BlockchainType? blockchainType,
    bool showStatus = true,
    void Function({
      required CryptoAccount cryptoAccount,
      required MessageHandler messageHandler,
    })? onComplete,
  }) async {}
}

class MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

class MockAltmeChatSupportCubit extends MockCubit<ChatRoomState>
    implements AltmeChatSupportCubit {}

class MockMatrixNotificationCubit extends MockCubit<ChatRoomState>
    implements MatrixNotificationCubit {}

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

class MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class MockOIDC4VC extends Mock implements OIDC4VC {}

class MockActivityLogManager extends Mock implements ActivityLogManager {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {
  @override
  Future<void> loadAllCredentials({
    required BlockchainType blockchainType,
  }) async {}
}

class MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class MockWalletConnectCubit extends MockCubit<WalletConnectState>
    implements WalletConnectCubit {}

void main() {
  late DIDKitProvider didKitProvider;
  late KeyGenerator keyGenerator;
  late HomeCubit homeCubit;
  late WalletCubit walletCubit;
  late SplashCubit splashCubit;
  late AltmeChatSupportCubit altmeChatSupportCubit;
  late MatrixNotificationCubit matrixNotificationCubit;
  late OnboardingCubit onboardingCubit;
  late MockSecureStorageProvider secureStorageProvider;
  late MockOIDC4VC oidc4vc;
  late MockActivityLogManager activityLogManager;
  late MockQRCodeScanCubit qrCodeScanCubit;
  late MockCredentialsCubit credentialsCubit;
  late MockWalletConnectCubit walletConnectCubit;

  const mnemonicString =
      'notice photo opera keen climb agent soft parrot best joke field devote';

  final expectedP256Jwk = {
    'kty': 'EC',
    'crv': 'P-256',
    'd': 's_wb6Ef1ardGsT5Il6WLRvQ9Zu0lp7I2OVwtzT5iQpo',
    'x': 'MZZjpNhZGGxqBcPXq499FVC2iu5FcZWwti5u8hgMUaI',
    'y': 'KD4zffV54PZUsQzTzVgoVlWHwKqogRF3JpKQnIGwIRM',
  };

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    didKitProvider = MockDIDKitProvider();
    keyGenerator = KeyGenerator();
    homeCubit = MockHomeCubit();
    splashCubit = MockSplashCubit();
    walletCubit = MockWalletCubit();
    altmeChatSupportCubit = MockAltmeChatSupportCubit();
    matrixNotificationCubit = MockMatrixNotificationCubit();
    onboardingCubit = OnboardingCubit();
    secureStorageProvider = MockSecureStorageProvider();
    oidc4vc = MockOIDC4VC();
    activityLogManager = MockActivityLogManager();
    credentialsCubit = MockCredentialsCubit();
    qrCodeScanCubit = MockQRCodeScanCubit();
    walletConnectCubit = MockWalletConnectCubit();
    when(() => secureStorageProvider.get(any())).thenAnswer((_) async => '');

    when(() => secureStorageProvider.set(any(), any()))
        .thenAnswer((_) async => Future<void>.value());

    when(
      () => secureStorageProvider.get(
        SecureStorageKeys.profileType,
      ),
    ).thenAnswer((_) async => 'ProfileType.ebsiV3');

    when(
      () => secureStorageProvider.get(
        SecureStorageKeys.enterpriseProfileSetting,
      ),
    ).thenAnswer((_) async => jsonEncode(ProfileSetting.initial()));

    when(
      () => secureStorageProvider.get(
        SecureStorageKeys.ssiMnemonic,
      ),
    ).thenAnswer((_) async => mnemonicString);

    when(
      () => p256PrivateKeyFromMnemonics(
        mnemonic: mnemonicString,
        indexValue: 5,
      ),
    ).thenAnswer((_) => jsonEncode(expectedP256Jwk));
  });

  group('ProtectWallet Page', () {
    late MockNavigator navigator;

    setUpAll(() {
      navigator = MockNavigator();

      when(navigator.canPop).thenReturn(true);

      when(() => navigator.push<void>(any())).thenAnswer((_) async {});

      when(() => navigator.pushAndRemoveUntil<void>(any(), any()))
          .thenAnswer((_) async {});
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    ProtectWalletPage.route(),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/ProtectWalletPage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('renders ProtectWalletView', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: OnBoardingGenPhraseCubit(
                didKitProvider: didKitProvider,
                keyGenerator: keyGenerator,
                homeCubit: homeCubit,
                walletCubit: walletCubit,
                splashCubit: splashCubit,
                altmeChatSupportCubit: altmeChatSupportCubit,
                matrixNotificationCubit: matrixNotificationCubit,
                profileCubit: ProfileCubit(
                  didKitProvider: didKitProvider,
                  jwtDecode: JWTDecode(),
                  oidc4vc: oidc4vc,
                  secureStorageProvider: secureStorageProvider,
                  langCubit: MockLangCubit(),
                ),
                activityLogManager: activityLogManager,
                qrCodeScanCubit: qrCodeScanCubit,
                credentialsCubit: credentialsCubit,
                walletConnectCubit: walletConnectCubit,
              ),
            ),
            BlocProvider<HomeCubit>.value(value: homeCubit),
            BlocProvider<WalletCubit>.value(value: walletCubit),
            BlocProvider<SplashCubit>.value(value: splashCubit),
            BlocProvider<AltmeChatSupportCubit>.value(
              value: altmeChatSupportCubit,
            ),
            BlocProvider<ProfileCubit>.value(
              value: ProfileCubit(
                didKitProvider: didKitProvider,
                jwtDecode: JWTDecode(),
                oidc4vc: oidc4vc,
                secureStorageProvider: secureStorageProvider,
                langCubit: MockLangCubit(),
              ),
            ),
            BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
          ],
          child: const ProtectWalletPage(),
        ),
      );

      expect(find.byType(ProtectWalletView), findsOneWidget);
    });

    testWidgets('renders UI correctly', (tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: onBoardingGenPhraseCubit,
            ),
            BlocProvider(
              create: (context) => profileCubit,
            ),
          ],
          child: ProtectWalletView(
            profileCubit: profileCubit,
            onBoardingGenPhraseCubit: onBoardingGenPhraseCubit,
            onboardingCubit: onboardingCubit,
          ),
        ),
      );

      expect(find.byType(BasePage), findsOneWidget);
      expect(find.byType(ProtectWidget), findsNWidgets(3));
    });

    testWidgets(
        'navigates to OnBoardingVerifyPhrasePage when Verify Now button'
        ' is tapped', (tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: BlocProvider.value(
            value: onBoardingGenPhraseCubit,
            child: const OnBoardingGenPhraseView(),
          ),
        ),
      );

      await tester.tap(find.text('Verify Now'.toUpperCase()));

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/OnBoardingVerifyPhrasePage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('should navigate to EnterNewPinCodePage on PIN Unlock tap',
        (WidgetTester tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: onBoardingGenPhraseCubit,
              ),
              BlocProvider(
                create: (context) => profileCubit,
              ),
            ],
            child: ProtectWalletView(
              profileCubit: profileCubit,
              onBoardingGenPhraseCubit: onBoardingGenPhraseCubit,
              onboardingCubit: onboardingCubit,
            ),
          ),
        ),
      );

      await tester.tap(find.text('PIN unlock'));

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/enterPinCodePage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'should navigate to ActiviateBiometricsPage on Biometric unlock tap',
        (WidgetTester tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: onBoardingGenPhraseCubit,
              ),
              BlocProvider(
                create: (context) => profileCubit,
              ),
            ],
            child: ProtectWalletView(
              profileCubit: profileCubit,
              onBoardingGenPhraseCubit: onBoardingGenPhraseCubit,
              onboardingCubit: onboardingCubit,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Biometric unlock'));

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/activiateBiometricsPage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'should navigate to ActiviateBiometricsPage on'
        ' PIN unlock + Biometric (2FA) tap', (WidgetTester tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: onBoardingGenPhraseCubit,
              ),
              BlocProvider(
                create: (context) => profileCubit,
              ),
            ],
            child: ProtectWalletView(
              profileCubit: profileCubit,
              onBoardingGenPhraseCubit: onBoardingGenPhraseCubit,
              onboardingCubit: onboardingCubit,
            ),
          ),
        ),
      );

      await tester.tap(find.text('PIN unlock + Biometric (2FA)'));

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/enterPinCodePage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'createImportAccount when routeType is WalletRouteType.create'
        ' and byPassScreen is false', (WidgetTester tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: onBoardingGenPhraseCubit,
              ),
              BlocProvider(
                create: (context) => profileCubit,
              ),
            ],
            child: ProtectWalletView(
              profileCubit: profileCubit,
              onBoardingGenPhraseCubit: onBoardingGenPhraseCubit,
              onboardingCubit: onboardingCubit,
              routeType: WalletRouteType.create,
            ),
          ),
        ),
      );

      final dynamic state = tester.state(find.byType(ProtectWalletView));
      await state.createImportAccount(byPassScreen: false);
      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/onBoardingGenPhrasePage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'createImportAccount when routeType is WalletRouteType.create'
        ' and byPassScreen is true', (WidgetTester tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: onBoardingGenPhraseCubit,
              ),
              BlocProvider(
                create: (context) => ProfileCubit(
                  didKitProvider: didKitProvider,
                  jwtDecode: JWTDecode(),
                  oidc4vc: oidc4vc,
                  secureStorageProvider: secureStorageProvider,
                  langCubit: MockLangCubit(),
                ),
              ),
            ],
            child: ProtectWalletView(
              profileCubit: profileCubit,
              onBoardingGenPhraseCubit: onBoardingGenPhraseCubit,
              onboardingCubit: onboardingCubit,
              routeType: WalletRouteType.create,
            ),
          ),
        ),
      );

      final dynamic state = tester.state(find.byType(ProtectWalletView));
      await state.createImportAccount(byPassScreen: true);
      expect(onBoardingGenPhraseCubit.state.status, AppStatus.success);

      await tester.pumpAndSettle();
      verify(
        () => navigator.pushAndRemoveUntil<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/walletReadyPage'),
            ),
          ),
          any(that: isA<RoutePredicate>()),
        ),
      ).called(1);
    });

    testWidgets('createImportAccount when routeType is WalletRouteType.import',
        (WidgetTester tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: onBoardingGenPhraseCubit,
              ),
              BlocProvider(
                create: (context) => profileCubit,
              ),
            ],
            child: ProtectWalletView(
              profileCubit: profileCubit,
              onBoardingGenPhraseCubit: onBoardingGenPhraseCubit,
              onboardingCubit: onboardingCubit,
              routeType: WalletRouteType.import,
            ),
          ),
        ),
      );

      final dynamic state = tester.state(find.byType(ProtectWalletView));
      await state.createImportAccount(byPassScreen: false);
      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/ImportWalletPage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('correct value of byPassscreen', (WidgetTester tester) async {
      final profileCubit = ProfileCubit(
        didKitProvider: didKitProvider,
        jwtDecode: JWTDecode(),
        oidc4vc: oidc4vc,
        secureStorageProvider: secureStorageProvider,
        langCubit: MockLangCubit(),
      );

      final onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        qrCodeScanCubit: qrCodeScanCubit,
        credentialsCubit: credentialsCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: onBoardingGenPhraseCubit,
              ),
              BlocProvider(
                create: (context) => profileCubit,
              ),
            ],
            child: ProtectWalletView(
              profileCubit: profileCubit,
              onBoardingGenPhraseCubit: onBoardingGenPhraseCubit,
              onboardingCubit: onboardingCubit,
              routeType: WalletRouteType.import,
            ),
          ),
        ),
      );

      final dynamic state = tester.state(find.byType(ProtectWalletView));
      expect(state.byPassScreen, !Parameters.walletHandlesCrypto);
    });
  });
}
