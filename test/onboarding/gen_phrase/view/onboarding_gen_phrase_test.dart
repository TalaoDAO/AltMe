import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/connection_bridge/wallet_connect/cubit/wallet_connect_cubit.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
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
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

class MockDIDKitProvider extends Mock implements DIDKitProvider {}

class MockKeyGenerator extends Mock implements KeyGenerator {}

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

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
  @override
  final state = ProfileState(model: ProfileModel.empty());
}

class MockActivityLogManager extends Mock implements ActivityLogManager {}

class MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {
  @override
  Future<void> loadAllCredentials() async {}
}

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
  late ProfileCubit profileCubit;
  late OnboardingCubit onboardingCubit;
  late MockActivityLogManager activityLogManager;
  late MockQRCodeScanCubit qrCodeScanCubit;
  late MockCredentialsCubit credentialsCubit;
  late MockWalletConnectCubit walletConnectCubit;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    didKitProvider = MockDIDKitProvider();
    keyGenerator = MockKeyGenerator();
    homeCubit = MockHomeCubit();
    splashCubit = MockSplashCubit();
    walletCubit = MockWalletCubit();
    altmeChatSupportCubit = MockAltmeChatSupportCubit();
    matrixNotificationCubit = MockMatrixNotificationCubit();
    profileCubit = MockProfileCubit();
    onboardingCubit = OnboardingCubit();
    activityLogManager = MockActivityLogManager();
    qrCodeScanCubit = MockQRCodeScanCubit();
    credentialsCubit = MockCredentialsCubit();
    walletConnectCubit = MockWalletConnectCubit();
  });

  group('OnBoarding GenPhrase Page', () {
    late OnBoardingGenPhraseCubit onBoardingGenPhraseCubit;

    late MockNavigator navigator;

    setUpAll(() {
      onBoardingGenPhraseCubit = OnBoardingGenPhraseCubit(
        didKitProvider: didKitProvider,
        keyGenerator: keyGenerator,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
        altmeChatSupportCubit: altmeChatSupportCubit,
        matrixNotificationCubit: matrixNotificationCubit,
        profileCubit: profileCubit,
        activityLogManager: activityLogManager,
        credentialsCubit: credentialsCubit,
        qrCodeScanCubit: qrCodeScanCubit,
        walletConnectCubit: walletConnectCubit,
      );
      navigator = MockNavigator();
      when(navigator.canPop).thenReturn(true);

      when(() => navigator.push<void>(any())).thenAnswer((_) async {});
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
                    OnBoardingGenPhrasePage.route(),
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
              whereName: equals('/onBoardingGenPhrasePage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('renders OnBoardingGenPhraseView', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: onBoardingGenPhraseCubit,
            ),
            BlocProvider<HomeCubit>.value(value: homeCubit),
            BlocProvider<WalletCubit>.value(value: walletCubit),
            BlocProvider<SplashCubit>.value(value: splashCubit),
            BlocProvider<AltmeChatSupportCubit>.value(
              value: altmeChatSupportCubit,
            ),
            BlocProvider<MatrixNotificationCubit>.value(
              value: matrixNotificationCubit,
            ),
            BlocProvider<ProfileCubit>.value(value: profileCubit),
          ],
          child: const OnBoardingGenPhrasePage(),
        ),
      );

      expect(find.byType(OnBoardingGenPhraseView), findsOneWidget);
    });

    testWidgets('renders UI correctly', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: onBoardingGenPhraseCubit,
          child: const OnBoardingGenPhraseView(),
        ),
      );

      expect(find.byType(BasePage), findsOneWidget);
      expect(find.byType(MStepper), findsOneWidget);
      expect(find.byType(MnemonicDisplay), findsOneWidget);
      expect(find.byType(MyElevatedButton), findsOneWidget);
      expect(find.byType(MyElevatedButton), findsOneWidget);
    });

    testWidgets(
        'navigates to OnBoardingVerifyPhrasePage when Verify Now button'
        ' is tapped', (tester) async {
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

    testWidgets('Verify Later button triggers onboarding processing',
        (WidgetTester tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: onboardingCubit,
            ),
            BlocProvider.value(
              value: onBoardingGenPhraseCubit,
            ),
          ],
          child: const OnBoardingGenPhraseView(),
        ),
      );
      await tester.tap(find.text('Verify Later'.toUpperCase()));

      // Verify the real Cubit method call
      expect(onBoardingGenPhraseCubit.state.message, isNotNull);
      expect(onboardingCubit.state.status, AppStatus.loading);
    });
  });
}
