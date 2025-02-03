import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
  @override
  final state = ProfileState(
    model: ProfileModel(
      walletType: WalletType.personal,
      walletProtectionType: WalletProtectionType.FA2,
      isDeveloperMode: false,
      profileType: ProfileType.custom,
      profileSetting: ProfileSetting.initial(),
    ),
  );
}

class MockLocalAuthApi extends Mock implements LocalAuthApi {}

void main() {
  late ActiveBiometricsCubit activeBiometricsCubit;
  late MockLocalAuthApi localAuthApi;
  late MockProfileCubit mockProfileCubit;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    mockProfileCubit = MockProfileCubit();
    activeBiometricsCubit =
        ActiveBiometricsCubit(profileCubit: mockProfileCubit);
    localAuthApi = MockLocalAuthApi();
  });

  group('OnBoarding GenPhrase Page', () {
    late MockNavigator navigator;

    setUpAll(() {
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
                    ActiviateBiometricsPage.route(
                      isFromOnboarding: true,
                      onAction: ({required bool isEnabled}) {},
                      localAuthApi: localAuthApi,
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
              whereName: equals('/activiateBiometricsPage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('renders ActivateBiometricsView', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: activeBiometricsCubit,
            ),
            BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
          ],
          child: ActiviateBiometricsPage(
            isFromOnboarding: true,
            onAction: ({required bool isEnabled}) {},
            localAuthApi: localAuthApi,
          ),
        ),
      );

      expect(find.byType(ActivateBiometricsView), findsOneWidget);
    });

    testWidgets('renders UI correctly', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: activeBiometricsCubit,
          child: ActivateBiometricsView(
            isFromOnboarding: true,
            onAction: ({required bool isEnabled}) {},
            localAuthApi: localAuthApi,
          ),
        ),
      );

      expect(find.byType(BasePage), findsOneWidget);
      expect(find.byType(BiometricsSwitch), findsOneWidget);
      expect(
        find.text('Activate Biometrics\nto add a securtiy layer'),
        findsOneWidget,
      );
    });

    testWidgets(
        'MyElevatedButton should be enabled and trigger onAction callback',
        (tester) async {
      bool callbackCalled = false;

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: BlocProvider.value(
            value: activeBiometricsCubit,
            child: ActivateBiometricsView(
              isFromOnboarding: true,
              localAuthApi: localAuthApi,
              onAction: ({required bool isEnabled}) {
                callbackCalled = isEnabled;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Next'.toUpperCase()));

      expect(callbackCalled, true);
    });

    group('BiometricsSwitch', () {
      testWidgets('show Diloag when biometrics is not available',
          (tester) async {
        when(() => localAuthApi.hasBiometrics())
            .thenAnswer((_) => Future.value(false));

        await tester.pumpApp(
          MockNavigatorProvider(
            navigator: navigator,
            child: BlocProvider.value(
              value: activeBiometricsCubit,
              child: ActivateBiometricsView(
                isFromOnboarding: true,
                localAuthApi: localAuthApi,
                onAction: ({required bool isEnabled}) {},
              ),
            ),
          ),
        );

        await tester.tap(find.byType(CupertinoSwitch));
        await tester.pump();
        expect(find.byType(ConfirmDialog), findsOneWidget);
        expect(find.text('Biometrics not supported'), findsOneWidget);
      });

      testWidgets('show Diloag when biometrics is available', (tester) async {
        when(() => localAuthApi.hasBiometrics())
            .thenAnswer((_) => Future.value(true));
        when(
          () => localAuthApi.authenticate(
            localizedReason: 'Scan Fingerprint to Authenticate',
          ),
        ).thenAnswer((_) => Future.value(true));

        await tester.pumpApp(
          MockNavigatorProvider(
            navigator: navigator,
            child: BlocProvider.value(
              value: activeBiometricsCubit,
              child: ActivateBiometricsView(
                isFromOnboarding: true,
                localAuthApi: localAuthApi,
                onAction: ({required bool isEnabled}) {},
              ),
            ),
          ),
        );

        await tester.tap(find.byType(CupertinoSwitch));
        expect(find.byType(ConfirmDialog), findsNothing);
        expect(activeBiometricsCubit.state, false);
      });
    });
  });
}
