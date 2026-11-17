import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/kyc_verification/kyc_verification.dart';
import 'package:altme/route/route_name.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallet_ui/wallet_ui.dart';

import '../../../helpers/helpers.dart';

class _MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class _MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

class _MockDeepLinkCubit extends MockCubit<String> implements DeepLinkCubit {}

class _MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {
  @override
  final state = FlavorMode.development;
}

class _MockMnemonicNeedVerificationCubit extends MockCubit<bool>
    implements MnemonicNeedVerificationCubit {}

class _MockKycVerificationCubit extends MockCubit<KycVerificationState>
    implements KycVerificationCubit {}

/// Records the routes pushed on the app's navigator.
class _PushObserver extends NavigatorObserver {
  final pushed = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
  }

  /// The scanner pages pushed so far. The routes are not pumped: the Scan tab
  /// would open the camera.
  List<QrCodeScanPage> scanners(BuildContext context) => [
    for (final route in pushed)
      if (route.settings.name == QRCODE_SCAN_PAGE)
        (route as MaterialPageRoute<dynamic>).builder(context)
            as QrCodeScanPage,
  ];
}

void main() {
  late _MockHomeCubit homeCubit;
  late _MockProfileCubit profileCubit;
  late _MockQRCodeScanCubit qrCodeScanCubit;
  late _MockSplashCubit splashCubit;
  late _MockDeepLinkCubit deepLinkCubit;
  late _MockMnemonicNeedVerificationCubit mnemonicCubit;
  late _MockKycVerificationCubit kycCubit;
  late StreamController<String> deepLinks;
  late DashboardCubit dashboardCubit;
  late _PushObserver observer;

  void withWallet({required bool hasWallet}) {
    when(() => homeCubit.state).thenReturn(
      hasWallet
          ? const HomeState(homeStatus: HomeStatus.hasWallet)
          // The default state, as on the first frame before the splash
          // resolves.
          : const HomeState(),
    );
  }

  setUp(() {
    homeCubit = _MockHomeCubit();
    profileCubit = _MockProfileCubit();
    qrCodeScanCubit = _MockQRCodeScanCubit();
    splashCubit = _MockSplashCubit();
    deepLinkCubit = _MockDeepLinkCubit();
    mnemonicCubit = _MockMnemonicNeedVerificationCubit();
    kycCubit = _MockKycVerificationCubit();
    deepLinks = StreamController<String>();
    observer = _PushObserver();

    withWallet(hasWallet: true);
    when(
      () => profileCubit.state,
    ).thenReturn(ProfileState(model: ProfileModel.empty()));
    when(() => qrCodeScanCubit.state).thenReturn(const QRCodeScanState());
    when(() => qrCodeScanCubit.deepLink()).thenAnswer((_) async {});
    when(() => splashCubit.state).thenReturn(const SplashState());
    when(() => mnemonicCubit.state).thenReturn(false);
    when(() => kycCubit.state).thenReturn(const KycVerificationState());
    whenListen(deepLinkCubit, deepLinks.stream, initialState: '');
  });

  tearDown(() async {
    await deepLinks.close();
    await dashboardCubit.close();
  });

  List<BlocProvider<dynamic>> providers() => [
    BlocProvider<HomeCubit>.value(value: homeCubit),
    BlocProvider<ProfileCubit>.value(value: profileCubit),
    BlocProvider<QRCodeScanCubit>.value(value: qrCodeScanCubit),
    BlocProvider<SplashCubit>.value(value: splashCubit),
    BlocProvider<DeepLinkCubit>.value(value: deepLinkCubit),
    BlocProvider<MnemonicNeedVerificationCubit>.value(value: mnemonicCubit),
    BlocProvider<KycVerificationCubit>.value(value: kycCubit),
    BlocProvider<DashboardCubit>.value(value: dashboardCubit),
    BlocProvider<FlavorCubit>.value(value: _MockFlavorCubit()),
  ];

  Widget dashboard({MediaQueryData Function(MediaQueryData)? mediaQuery}) {
    Widget view = DashboardView(tabBuilder: (tab) => Text('page ${tab.name}'));
    if (mediaQuery != null) {
      final child = view;
      view = Builder(
        builder: (context) =>
            MediaQuery(data: mediaQuery(MediaQuery.of(context)), child: child),
      );
    }
    return MultiBlocProvider(providers: providers(), child: view);
  }

  /// Pumps the dashboard, then the frame that runs the `initState` work
  /// (splash authenticated, queued deep link).
  Future<void> pump(
    WidgetTester tester, {
    MediaQueryData Function(MediaQueryData)? mediaQuery,
  }) async {
    // Built in the test body: a cubit made in setUp lives outside the
    // fake-async zone.
    dashboardCubit = DashboardCubit();
    await tester.pumpApp(
      dashboard(mediaQuery: mediaQuery),
      navigatorObservers: [observer],
    );
    await tester.pump(Duration.zero);
  }

  Finder barItem(String label) => find.descendant(
    of: find.byType(WalletBottomBar),
    matching: find.text(label),
  );

  Finder centreButton() => find.byType(WalletBottomBarCenterButton);

  BuildContext appContext(WidgetTester tester) =>
      tester.element(find.byType(DashboardView));

  group('DashboardView', () {
    testWidgets('shows Wallet first and switches tabs from the bar', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('page wallet'), findsOneWidget);
      expect(find.text('My wallet'), findsOneWidget);
      verify(() => splashCubit.authenticated()).called(1);

      await tester.tap(barItem('Discover'));
      await tester.pump();
      expect(dashboardCubit.state.tab, DashboardTab.discover);
      expect(find.text('page discover'), findsOneWidget);

      await tester.tap(barItem('Search'));
      await tester.pump();
      expect(dashboardCubit.state.tab, DashboardTab.search);
      expect(find.text('page search'), findsOneWidget);

      await tester.tap(barItem('Wallet'));
      await tester.pump();
      expect(find.text('page wallet'), findsOneWidget);
    });

    testWidgets('follows a tab selected elsewhere', (tester) async {
      await pump(tester);

      dashboardCubit.selectTab(DashboardTab.discover);
      // No frame is scheduled yet: the listener's jump schedules one.
      await tester.pumpAndSettle();

      expect(find.text('page discover'), findsOneWidget);
    });

    testWidgets('the centre button pushes the scanner on Scan', (tester) async {
      await pump(tester);

      await tester.tap(centreButton());

      final scanners = observer.scanners(appContext(tester));
      expect(scanners, hasLength(1));
      expect(scanners.single.initialTab, ScanPageTab.scan);
      // Never selected: the tab does not change.
      expect(dashboardCubit.state.tab, DashboardTab.wallet);
    });

    testWidgets('Present pushes the scanner on Present', (tester) async {
      await pump(tester);

      await tester.tap(barItem('Present'));

      final scanners = observer.scanners(appContext(tester));
      expect(scanners, hasLength(1));
      expect(scanners.single.initialTab, ScanPageTab.present);
      expect(dashboardCubit.state.tab, DashboardTab.wallet);
    });

    group('back', () {
      testWidgets('goes from another tab to Wallet', (tester) async {
        await pump(tester);
        await tester.tap(barItem('Discover'));
        await tester.pump();

        await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
        await tester.pump();

        expect(dashboardCubit.state.tab, DashboardTab.wallet);
        expect(find.text('page wallet'), findsOneWidget);
      });

      testWidgets('does nothing on Wallet', (tester) async {
        await pump(tester);

        final popped = await tester
            .state<NavigatorState>(find.byType(Navigator))
            .maybePop();
        await tester.pump();

        expect(popped, isTrue);
        expect(find.byType(DashboardView), findsOneWidget);
        expect(dashboardCubit.state.tab, DashboardTab.wallet);
      });
    });

    group('without a wallet', () {
      setUp(() => withWallet(hasWallet: false));

      testWidgets('guards a tab tapped on the first frame', (tester) async {
        await pump(tester);

        await tester.tap(barItem('Discover'));
        await tester.pump();

        expect(find.byType(WalletDialog), findsOneWidget);
        expect(dashboardCubit.state.tab, DashboardTab.wallet);
        expect(find.text('page wallet'), findsOneWidget);
      });

      for (final label in ['Wallet', 'Search', 'Present']) {
        testWidgets('guards $label', (tester) async {
          await pump(tester);

          await tester.tap(barItem(label));
          await tester.pump();

          expect(find.byType(WalletDialog), findsOneWidget);
          expect(observer.scanners(appContext(tester)), isEmpty);
          expect(dashboardCubit.state.tab, DashboardTab.wallet);
        });
      }

      testWidgets('guards the centre button', (tester) async {
        await pump(tester);

        await tester.tap(centreButton());
        await tester.pump();

        expect(find.byType(WalletDialog), findsOneWidget);
        expect(observer.scanners(appContext(tester)), isEmpty);
      });
    });

    testWidgets('handles a deep link arriving while on Discover', (
      tester,
    ) async {
      await pump(tester);
      await tester.tap(barItem('Discover'));
      await tester.pump();
      clearInteractions(qrCodeScanCubit);

      deepLinks.add('openid-credential-offer://?credential_offer=x');
      await tester.pump();

      verify(() => qrCodeScanCubit.deepLink()).called(1);
      expect(dashboardCubit.state.tab, DashboardTab.discover);
    });

    testWidgets('opens Settings from the header and keeps handling deep links '
        'while it is open', (tester) async {
      dashboardCubit = DashboardCubit();
      // The providers sit above the app, so the pushed page sees them.
      await tester.pumpApp(
        DashboardView(tabBuilder: (tab) => Text('page ${tab.name}')),
        wrapApp: (app) => MultiBlocProvider(providers: providers(), child: app),
        navigatorObservers: [observer],
      );
      await tester.pump(Duration.zero);

      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);
      clearInteractions(qrCodeScanCubit);

      deepLinks.add('openid-credential-offer://?credential_offer=x');
      await tester.pump();

      verify(() => qrCodeScanCubit.deepLink()).called(1);
      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets('hides the bar while the keyboard is open', (tester) async {
      await pump(
        tester,
        mediaQuery: (data) =>
            data.copyWith(viewInsets: const EdgeInsets.only(bottom: 300)),
      );

      expect(find.byType(WalletBottomBar), findsNothing);
    });

    testWidgets('lays the content out above the bar', (tester) async {
      await pump(tester);

      final pageBottom = tester.getBottomLeft(find.byType(PageView)).dy;
      final barTop = tester.getTopLeft(find.byType(WalletBottomBar)).dy;
      expect(pageBottom, lessThanOrEqualTo(barTop));
    });

    testWidgets('keeps the bar labels on one line at text scale 2', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 640)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await pump(
        tester,
        mediaQuery: (data) =>
            data.copyWith(textScaler: const TextScaler.linear(2)),
      );

      expect(tester.takeException(), isNull);
      for (final label in ['Wallet', 'Discover', 'Present', 'Search']) {
        final scaler = MediaQuery.textScalerOf(tester.element(barItem(label)));
        expect(scaler.scale(10), 13, reason: '$label is clamped to 1.3');
      }
    });
  });
}
