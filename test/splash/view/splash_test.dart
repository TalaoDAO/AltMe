import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/flavor/cubit/flavor_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/starter/starter.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:secure_storage/secure_storage.dart';

import '../../helpers/helpers.dart';

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

class MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

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
}

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {}

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
  @override
  final state = ProfileState(
    model: ProfileModel.empty(),
    status: AppStatus.success,
  );
}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {
  @override
  Future<void> loadAllCredentials() async {}
}

class MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {
  @override
  final state = const QRCodeScanState();
}

class MockScanCubit extends MockCubit<ScanState> implements ScanCubit {
  @override
  final state = const ScanState();
}

class MockBeaconCubit extends MockCubit<BeaconState> implements BeaconCubit {
  @override
  final state = const BeaconState();
}

class MockWalletConnectCubit extends MockCubit<WalletConnectState>
    implements WalletConnectCubit {
  @override
  final state = const WalletConnectState();
}

class MockEnterpriseCubit extends MockCubit<EnterpriseState>
    implements EnterpriseCubit {
  @override
  final state = const EnterpriseState();
}

class MockAdvanceSettingsCubit extends MockCubit<AdvanceSettingsState>
    implements AdvanceSettingsCubit {
  @override
  final state = const AdvanceSettingsState(
    isGamingEnabled: true,
    isIdentityEnabled: true,
    isProfessionalEnabled: true,
    isBlockchainAccountsEnabled: true,
    isEducationEnabled: true,
    isPassEnabled: true,
    isSocialMediaEnabled: true,
    isCommunityEnabled: true,
    isOtherEnabled: true,
    isFinanceEnabled: true,
    isHumanityProofEnabled: true,
    isWalletIntegrityEnabled: true,
  );

  @override
  Future<void> initialise() async {}

  @override
  Future<void> setState(AdvanceSettingsState newState) async {}
}

void main() {
  late FlavorCubit flavorCubit;
  late SplashCubit splashCubit;
  late WalletCubit walletCubit;
  late ProfileCubit profileCubit;
  late AdvanceSettingsCubit advanceSettingsCubit;
  late CredentialsCubit credentialsCubit;
  late ScanCubit scanCubit;
  late QRCodeScanCubit qRCodeScanCubit;
  late BeaconCubit beaconCubit;
  late WalletConnectCubit walletConnectCubit;
  late EnterpriseCubit enterpriseCubit;

  setUpAll(() async {
    flavorCubit = MockFlavorCubit();
    splashCubit = MockSplashCubit();
    walletCubit = MockWalletCubit();
    profileCubit = MockProfileCubit();
    advanceSettingsCubit = MockAdvanceSettingsCubit();
    credentialsCubit = MockCredentialsCubit();
    scanCubit = MockScanCubit();
    qRCodeScanCubit = MockQRCodeScanCubit();
    beaconCubit = MockBeaconCubit();
    walletConnectCubit = MockWalletConnectCubit();
    enterpriseCubit = MockEnterpriseCubit();
    when(() => splashCubit.state)
        .thenReturn(const SplashState(status: SplashStatus.init));
    when(() => splashCubit.initialiseApp()).thenAnswer((_) async {});
    when(() => flavorCubit.state).thenReturn(FlavorMode.development);
  });

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FlavorCubit>(create: (context) => flavorCubit),
        BlocProvider<BeaconCubit>(create: (context) => beaconCubit),
        BlocProvider<WalletConnectCubit>(
          create: (context) => walletConnectCubit,
        ),
        BlocProvider<ProfileCubit>(create: (context) => profileCubit),
        BlocProvider<AdvanceSettingsCubit>(
          create: (context) => advanceSettingsCubit,
        ),
        BlocProvider<WalletCubit>(create: (context) => walletCubit),
        BlocProvider<CredentialsCubit>(create: (context) => credentialsCubit),
        BlocProvider<EnterpriseCubit>(create: (context) => enterpriseCubit),
        BlocProvider<ScanCubit>(create: (context) => scanCubit),
        BlocProvider<QRCodeScanCubit>(create: (context) => qRCodeScanCubit),
        BlocProvider<SplashCubit>(create: (context) => splashCubit),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: SplashView(),
      ),
    );
  }

  group('SplashPage', () {
    testWidgets('renders SplashView', (tester) async {
      await tester.pumpApp(makeTestableWidget());
      await tester.pumpAndSettle();
      expect(find.byType(SplashView), findsOneWidget);
    });
  });

  group('SplashView', () {
    group('SplashStatus.init', () {
      testWidgets('only one BasePage widget is rendered', (tester) async {
        await tester.pumpApp(makeTestableWidget());
        await tester.pumpAndSettle();
        expect(find.byType(BasePage), findsOneWidget);
      });

      testWidgets('correct image is rendered for development flavor',
          (tester) async {
        when(() => flavorCubit.state).thenReturn(FlavorMode.development);
        await tester.pumpApp(makeTestableWidget());
        await tester.pumpAndSettle();
        final Image image =
            find.byType(Image).evaluate().single.widget as Image;
        final AssetImage assetImage = image.image as AssetImage;
        expect(assetImage.assetName, equals(ImageStrings.appLogoDev));
      });

      testWidgets('correct image is rendered for staging flavor',
          (tester) async {
        when(() => flavorCubit.state).thenReturn(FlavorMode.staging);
        await tester.pumpApp(makeTestableWidget());
        await tester.pumpAndSettle();
        final Image image =
            find.byType(Image).evaluate().single.widget as Image;
        final AssetImage assetImage = image.image as AssetImage;
        expect(assetImage.assetName, equals(ImageStrings.appLogoStage));
      });

      testWidgets('correct image is rendered for production flavor',
          (tester) async {
        when(() => flavorCubit.state).thenReturn(FlavorMode.production);
        await tester.pumpApp(makeTestableWidget());
        await tester.pumpAndSettle();
        final Image image =
            find.byType(Image).evaluate().single.widget as Image;
        final AssetImage assetImage = image.image as AssetImage;
        expect(assetImage.assetName, equals(ImageStrings.appLogo));
      });

      testWidgets('loading progress is animated correctly', (tester) async {
        whenListen(
          splashCubit,
          Stream.fromIterable(
            [
              const SplashState(
                status: SplashStatus.init,
                loadedValue: 0,
              ),
              const SplashState(
                status: SplashStatus.init,
                loadedValue: 1,
              ),
            ],
          ),
          initialState: const SplashState(
            status: SplashStatus.init,
            loadedValue: 1,
          ),
        );
        await tester.pumpApp(makeTestableWidget());
        await tester.pump(const Duration(milliseconds: 250));

        expect(find.byType(LoadingProgress), findsOneWidget);

        final midScale =
            tester.widget<LoadingProgress>(find.byType(LoadingProgress));
        expect(midScale.value, 0.5);

        await tester.pump(const Duration(milliseconds: 250));

        final finalScale =
            tester.widget<LoadingProgress>(find.byType(LoadingProgress));
        expect(finalScale.value, 1.0);
      });
    });

    group('Routing', () {
      testWidgets(
          '''navigates to StarterPage when state is SplashStatus.routeToOnboarding''',
          (tester) async {
        whenListen(
          splashCubit,
          Stream.fromIterable(
            [
              const SplashState(status: SplashStatus.init),
              const SplashState(status: SplashStatus.routeToOnboarding),
            ],
          ),
          initialState: const SplashState(status: SplashStatus.init),
        );

        await tester.pumpApp(makeTestableWidget());

        await tester.pumpAndSettle();
        expect(find.byType(StarterPage), findsOneWidget);
      });
    });
  });
}
