import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
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

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {}

class MockAltmeChatSupportCubit extends MockCubit<ChatRoomState>
    implements AltmeChatSupportCubit {}

class MockMatrixNotificationCubit extends MockCubit<ChatRoomState>
    implements MatrixNotificationCubit {}

class MockOnboardingCubit extends MockCubit<OnboardingState>
    implements OnboardingCubit {}

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

class MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class MockOIDC4VC extends Mock implements OIDC4VC {}

class MockActivityLogManager extends Mock implements ActivityLogManager {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {
  @override
  Future<void> loadAllCredentials() async {}
}

class MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class MockWalletConnectCubit extends MockCubit<WalletConnectState>
    implements WalletConnectCubit {}

void main() {
  late MockDIDKitProvider didKitProvider;
  late KeyGenerator keyGenerator;
  late MockHomeCubit homeCubit;
  late MockWalletCubit walletCubit;
  late MockSplashCubit splashCubit;
  late MockFlavorCubit flavorCubit;
  late AltmeChatSupportCubit altmeChatSupportCubit;
  late MatrixNotificationCubit matrixNotificationCubit;
  late MockOnboardingCubit onboardingCubit;
  late MockNavigator navigator;
  late MockSecureStorageProvider secureStorageProvider;
  late MockOIDC4VC oidc4vc;
  late MockActivityLogManager activityLogManager;
  late MockQRCodeScanCubit qrCodeScanCubit;
  late MockCredentialsCubit credentialsCubit;
  late MockWalletConnectCubit walletConnectCubit;

  const mnemonicString =
      'notice photo opera keen climb agent soft parrot best joke field devote';

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    didKitProvider = MockDIDKitProvider();
    keyGenerator = KeyGenerator();
    homeCubit = MockHomeCubit();
    walletCubit = MockWalletCubit();
    splashCubit = MockSplashCubit();
    flavorCubit = MockFlavorCubit();
    altmeChatSupportCubit = MockAltmeChatSupportCubit();
    matrixNotificationCubit = MockMatrixNotificationCubit();
    onboardingCubit = MockOnboardingCubit();
    navigator = MockNavigator();
    secureStorageProvider = MockSecureStorageProvider();
    oidc4vc = MockOIDC4VC();
    activityLogManager = MockActivityLogManager();
    qrCodeScanCubit = MockQRCodeScanCubit();
    credentialsCubit = MockCredentialsCubit();
    walletConnectCubit = MockWalletConnectCubit();
  });

  group('Onboarding Verify Phrase Test', () {
    setUpAll(() {
      when(() => secureStorageProvider.get(any())).thenAnswer((_) async => '');

      when(() => secureStorageProvider.set(any(), any()))
          .thenAnswer((_) async => Future<void>.value());

      when(navigator.canPop).thenReturn(true);
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});
      when(() => navigator.pushAndRemoveUntil<void>(any(), any()))
          .thenAnswer((_) async {});
      when(() => navigator.pushReplacement<void, void>(any()))
          .thenAnswer((_) async {});
    });

    testWidgets('is routable', (tester) async {
      when(() => flavorCubit.state).thenAnswer((_) => FlavorMode.development);
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    OnBoardingVerifyPhrasePage.route(
                      mnemonic: [],
                      isFromOnboarding: true,
                    ),
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
              whereName: equals('/OnBoardingVerifyPhrasePage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('renders ProtectWalletView', (tester) async {
      when(() => flavorCubit.state).thenAnswer((_) => FlavorMode.development);
      when(
        () => secureStorageProvider
            .get(SecureStorageKeys.enterpriseProfileSetting),
      ).thenAnswer((_) async => null);
      when(() => didKitProvider.keyToDID(any(), any())).thenReturn(
        'did:key:z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56',
      );
      when(() => didKitProvider.keyToVerificationMethod(any(), any()))
          .thenAnswer(
        (_) async => 'did:key:z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56',
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<OnBoardingVerifyPhraseCubit>.value(
              value: OnBoardingVerifyPhraseCubit(
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
                credentialsCubit: credentialsCubit,
                qrCodeScanCubit: qrCodeScanCubit,
                flavorCubit: flavorCubit,
                activityLogManager: activityLogManager,
                walletConnectCubit: walletConnectCubit,
              ),
            ),
            BlocProvider<HomeCubit>.value(value: homeCubit),
            BlocProvider<WalletCubit>.value(value: walletCubit),
            BlocProvider<MatrixNotificationCubit>.value(
              value: matrixNotificationCubit,
            ),
            BlocProvider<QRCodeScanCubit>.value(value: qrCodeScanCubit),
            BlocProvider<SplashCubit>.value(value: splashCubit),
            BlocProvider<AltmeChatSupportCubit>.value(
              value: altmeChatSupportCubit,
            ),
            BlocProvider<FlavorCubit>.value(value: flavorCubit),
            BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
            BlocProvider<ProfileCubit>.value(
              value: ProfileCubit(
                didKitProvider: didKitProvider,
                jwtDecode: JWTDecode(),
                oidc4vc: oidc4vc,
                secureStorageProvider: secureStorageProvider,
                langCubit: MockLangCubit(),
              ),
            ),
          ],
          child: const OnBoardingVerifyPhrasePage(
            mnemonic: [],
            isFromOnboarding: true,
          ),
        ),
      );
      expect(find.byType(OnBoardingVerifyPhraseView), findsOneWidget);
    });

    testWidgets('renders UI correctly', (tester) async {
      when(() => flavorCubit.state).thenAnswer((_) => FlavorMode.development);
      final onBoardingVerifyPhraseCubit = OnBoardingVerifyPhraseCubit(
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
        flavorCubit: flavorCubit,
        activityLogManager: activityLogManager,
        credentialsCubit: credentialsCubit,
        qrCodeScanCubit: qrCodeScanCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<OnBoardingVerifyPhraseCubit>.value(
              value: onBoardingVerifyPhraseCubit,
            ),
            BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
          ],
          child: OnBoardingVerifyPhraseView(
            mnemonic: mnemonicString.split(' '),
            isFromOnboarding: true,
            onBoardingVerifyPhraseCubit: onBoardingVerifyPhraseCubit,
            onboardingCubit: onboardingCubit,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BasePage), findsOneWidget);
      expect(find.byType(MStepper), findsOneWidget);
      expect(find.byType(PhraseWord), findsNWidgets(12));
    });

    testWidgets(
        'selects the phrase words correctly and state is verified and'
        ' emits Success when button is pressed and navigates to correct screen'
        ' when isFromOnboarding is false', (tester) async {
      when(() => flavorCubit.state).thenAnswer((_) => FlavorMode.development);
      when(() => onboardingCubit.emitOnboardingProcessing())
          .thenAnswer((_) async {});
      final onBoardingVerifyPhraseCubit = OnBoardingVerifyPhraseCubit(
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
        flavorCubit: flavorCubit,
        activityLogManager: activityLogManager,
        credentialsCubit: credentialsCubit,
        qrCodeScanCubit: qrCodeScanCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<OnBoardingVerifyPhraseCubit>.value(
                value: onBoardingVerifyPhraseCubit,
              ),
              BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
            ],
            child: OnBoardingVerifyPhraseView(
              mnemonic: mnemonicString.split(' '),
              isFromOnboarding: false,
              onBoardingVerifyPhraseCubit: onBoardingVerifyPhraseCubit,
              onboardingCubit: onboardingCubit,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // make sure all the phrases are selected
      for (int i = 0; i < 12; i++) {
        expect(
          onBoardingVerifyPhraseCubit.state.mnemonicStates[i].mnemonicStatus,
          MnemonicStatus.unselected,
        );
        await tester.tap(find.byKey(Key((i + 1).toString())));
        expect(
          onBoardingVerifyPhraseCubit.state.mnemonicStates[i].mnemonicStatus,
          MnemonicStatus.selected,
        );
      }

      expect(
        onBoardingVerifyPhraseCubit.state.isVerified,
        true,
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'.toUpperCase()));
      verify(() => onboardingCubit.emitOnboardingProcessing());

      verify(
        () => navigator.pushReplacement<void, void>(
          any(
            that: isRoute<void>(
              whereName: equals('/KeyVerifiedPage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'emits Success when button is pressed and navigates to correct screen'
        ' when isFromOnboarding is false', (tester) async {
      when(() => flavorCubit.state).thenAnswer((_) => FlavorMode.development);
      when(() => onboardingCubit.emitOnboardingProcessing())
          .thenAnswer((_) async {});
      final onBoardingVerifyPhraseCubit = OnBoardingVerifyPhraseCubit(
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
        flavorCubit: flavorCubit,
        activityLogManager: activityLogManager,
        credentialsCubit: credentialsCubit,
        qrCodeScanCubit: qrCodeScanCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<OnBoardingVerifyPhraseCubit>.value(
                value: onBoardingVerifyPhraseCubit,
              ),
              BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
            ],
            child: OnBoardingVerifyPhraseView(
              mnemonic: mnemonicString.split(' '),
              isFromOnboarding: true,
              onBoardingVerifyPhraseCubit: onBoardingVerifyPhraseCubit,
              onboardingCubit: onboardingCubit,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (int i = 0; i < 12; i++) {
        final key = Key((i + 1).toString());
        await tester.ensureVisible(find.byKey(key));
        await tester.tap(find.byKey(key));
      }

      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'.toUpperCase()));

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
    testWidgets('emits Error when error occurs', (tester) async {
      when(() => flavorCubit.state).thenAnswer((_) => FlavorMode.development);
      when(() => onboardingCubit.emitOnboardingProcessing())
          .thenAnswer((_) async {});
      when(
        () => secureStorageProvider.set(
          SecureStorageKeys.hasVerifiedMnemonics,
          'yes',
        ),
      ).thenThrow(Exception('Failed to set value'));

      final onBoardingVerifyPhraseCubit = OnBoardingVerifyPhraseCubit(
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
        flavorCubit: flavorCubit,
        activityLogManager: activityLogManager,
        credentialsCubit: credentialsCubit,
        qrCodeScanCubit: qrCodeScanCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<OnBoardingVerifyPhraseCubit>.value(
              value: onBoardingVerifyPhraseCubit,
            ),
            BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
          ],
          child: OnBoardingVerifyPhraseView(
            mnemonic: mnemonicString.split(' '),
            isFromOnboarding: true,
            onBoardingVerifyPhraseCubit: onBoardingVerifyPhraseCubit,
            onboardingCubit: onboardingCubit,
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (int i = 0; i < 12; i++) {
        final key = Key((i + 1).toString());
        await tester.ensureVisible(find.byKey(key));
        await tester.tap(find.byKey(key));
      }

      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'.toUpperCase()));

      await tester.pumpAndSettle();

      expect(onBoardingVerifyPhraseCubit.state.message, isNotNull);
    });

    testWidgets('choose wrong mnemonics in production mode', (tester) async {
      when(() => flavorCubit.state).thenAnswer((_) => FlavorMode.production);

      final onBoardingVerifyPhraseCubit = OnBoardingVerifyPhraseCubit(
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
        flavorCubit: flavorCubit,
        activityLogManager: activityLogManager,
        credentialsCubit: credentialsCubit,
        qrCodeScanCubit: qrCodeScanCubit,
        walletConnectCubit: walletConnectCubit,
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<OnBoardingVerifyPhraseCubit>.value(
              value: onBoardingVerifyPhraseCubit,
            ),
            BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
          ],
          child: OnBoardingVerifyPhraseView(
            mnemonic: mnemonicString.split(' '),
            isFromOnboarding: false,
            onBoardingVerifyPhraseCubit: onBoardingVerifyPhraseCubit,
            onboardingCubit: onboardingCubit,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // to make sure that index is not 0
      final index = onBoardingVerifyPhraseCubit.state.mnemonicStates
          .indexWhere((element) => element.order != 1);

      final mnemonicState =
          onBoardingVerifyPhraseCubit.state.mnemonicStates[index];

      expect(mnemonicState.mnemonicStatus, MnemonicStatus.unselected);

      await tester.tap(find.byKey(Key(mnemonicState.order.toString())));

      await tester.tap(find.byKey(Key(mnemonicState.order.toString())));

      await tester.pumpAndSettle();
      expect(
        onBoardingVerifyPhraseCubit.state.mnemonicStates[index].mnemonicStatus,
        MnemonicStatus.unselected,
      );
    });
  });
}
