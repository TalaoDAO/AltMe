import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
  @override
  final state = ProfileState(model: ProfileModel.empty());
}

class MockConfettiController extends Mock implements ConfettiController {
  @override
  final duration = const Duration(milliseconds: 100);

  @override
  final state = ConfettiControllerState.stopped;
}

void main() {
  late MockProfileCubit profileCubit;
  late WalletReadyCubit walletReadyCubit;
  late MockNavigator navigator;
  late MockConfettiController confettiController;

  setUpAll(() {
    profileCubit = MockProfileCubit();
    walletReadyCubit = WalletReadyCubit();
    navigator = MockNavigator();
    confettiController = MockConfettiController();
  });

  group('Wallet Ready Page Test', () {
    setUpAll(() {
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
                    WalletReadyPage.route(),
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
              whereName: equals('/walletReadyPage'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('renders WalletReadyView', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<WalletReadyCubit>.value(
              value: walletReadyCubit,
            ),
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider<FlavorCubit>.value(
              value: FlavorCubit(FlavorMode.development),
            ),
            BlocProvider<OnboardingCubit>.value(
              value: OnboardingCubit(),
            ),
          ],
          child: const WalletReadyPage(),
        ),
      );

      expect(find.byType(WalletReadyView), findsOneWidget);
    });

    testWidgets('renders UI correctly', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<WalletReadyCubit>.value(
              value: walletReadyCubit,
            ),
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider<FlavorCubit>.value(
              value: FlavorCubit(FlavorMode.development),
            ),
            BlocProvider<OnboardingCubit>.value(
              value: OnboardingCubit(),
            ),
          ],
          child: WalletReadyView(
            profileCubit: profileCubit,
            walletReadyCubit: walletReadyCubit,
            confettiController: confettiController,
          ),
        ),
      );

      expect(find.byType(BasePage), findsOneWidget);
      expect(find.byType(ConfettiWidget), findsOneWidget);
    });

    testWidgets('toggles agreement value when checkbox is pressed',
        (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<WalletReadyCubit>.value(
              value: walletReadyCubit,
            ),
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider<FlavorCubit>.value(
              value: FlavorCubit(FlavorMode.development),
            ),
            BlocProvider<OnboardingCubit>.value(
              value: OnboardingCubit(),
            ),
          ],
          child: WalletReadyView(
            profileCubit: profileCubit,
            walletReadyCubit: walletReadyCubit,
            confettiController: confettiController,
          ),
        ),
      );

      final isAgreeWithTerms = walletReadyCubit.state.isAgreeWithTerms;

      await tester.tap(find.byType(Checkbox));

      expect(walletReadyCubit.state.isAgreeWithTerms, !isAgreeWithTerms);
    });

    testWidgets(
        'toggles agreement value when text "I agree to the " is pressed',
        (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<WalletReadyCubit>.value(
              value: walletReadyCubit,
            ),
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider<FlavorCubit>.value(
              value: FlavorCubit(FlavorMode.development),
            ),
            BlocProvider<OnboardingCubit>.value(
              value: OnboardingCubit(),
            ),
          ],
          child: WalletReadyView(
            profileCubit: profileCubit,
            walletReadyCubit: walletReadyCubit,
            confettiController: confettiController,
          ),
        ),
      );

      final isAgreeWithTerms = walletReadyCubit.state.isAgreeWithTerms;

      await tester.tap(find.text('I agree to the '));

      expect(walletReadyCubit.state.isAgreeWithTerms, !isAgreeWithTerms);
    });

    testWidgets(
        'navigatest to onboardingTosPage when text "termsAndConditions " is'
        ' pressed', (tester) async {
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<WalletReadyCubit>.value(
                value: walletReadyCubit,
              ),
              BlocProvider<ProfileCubit>.value(value: profileCubit),
              BlocProvider<FlavorCubit>.value(
                value: FlavorCubit(FlavorMode.development),
              ),
              BlocProvider<OnboardingCubit>.value(
                value: OnboardingCubit(),
              ),
            ],
            child: WalletReadyView(
              profileCubit: profileCubit,
              walletReadyCubit: walletReadyCubit,
              confettiController: confettiController,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Terms and conditions'.toLowerCase()));

      verify(
        () => navigator.pushAndRemoveUntil<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/onBoardingTermsPage'),
            ),
          ),
          any(
            that: isA<RoutePredicate>(),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'navigatest to dashboardPage when text "start " is'
        ' pressed', (tester) async {
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<WalletReadyCubit>.value(
                value: walletReadyCubit,
              ),
              BlocProvider<ProfileCubit>.value(value: profileCubit),
              BlocProvider<FlavorCubit>.value(
                value: FlavorCubit(FlavorMode.development),
              ),
              BlocProvider<OnboardingCubit>.value(
                value: OnboardingCubit(),
              ),
            ],
            child: WalletReadyView(
              profileCubit: profileCubit,
              walletReadyCubit: walletReadyCubit,
              confettiController: confettiController,
            ),
          ),
        ),
      );

      if (!walletReadyCubit.state.isAgreeWithTerms) {
        await tester.tap(find.text('I agree to the '));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.text('Start'.toUpperCase()));

      verify(
        () => navigator.pushAndRemoveUntil<void>(
          any(
            that: isRoute<void>(
              whereName: equals(AltMeStrings.dashBoardPage),
            ),
          ),
          any(
            that: isA<RoutePredicate>(),
          ),
        ),
      ).called(1);
    });
  });
}
