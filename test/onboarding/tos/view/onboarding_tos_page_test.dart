import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

class MockOnBoardingTosCubit extends MockCubit<OnBoardingTosState>
    implements OnBoardingTosCubit {}

void main() {
  group('OnBoarding Terms Page', () {
    late MockOnBoardingTosCubit onBoardingTosCubit;
    late MockNavigator navigator;

    setUpAll(() {
      onBoardingTosCubit = MockOnBoardingTosCubit();
      navigator = MockNavigator();
      when(navigator.canPop).thenReturn(true);

      when(() => navigator.push<void>(any())).thenAnswer((_) async {});
      when(
        () => navigator.pushAndRemoveUntil<void>(any(), any()),
      ).thenAnswer((_) async {});
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push<void>(OnBoardingTosPage.route());
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
          any(that: isRoute<void>(whereName: equals('/onBoardingTermsPage'))),
        ),
      ).called(1);
    });

    testWidgets('renders OnBoardingTosPage', (tester) async {
      when(
        () => onBoardingTosCubit.state,
      ).thenReturn(const OnBoardingTosState());
      await tester.pumpApp(
        BlocProvider<OnBoardingTosCubit>.value(
          value: onBoardingTosCubit,
          child: const OnBoardingTosPage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosView), findsOneWidget);
    });

    testWidgets('nothing happens when button is pressed', (tester) async {
      when(
        () => onBoardingTosCubit.state,
      ).thenReturn(const OnBoardingTosState());

      await tester.pumpApp(
        BlocProvider<OnBoardingTosCubit>(
          create: (context) => onBoardingTosCubit,
          child: OnBoardingTosView(onBoardingTosCubit: onBoardingTosCubit),
        ),
      );

      await tester.tap(find.byType(MyElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosView), findsOneWidget);
    });

    testWidgets('checkboxes toggle state', (WidgetTester tester) async {
      when(
        () => onBoardingTosCubit.state,
      ).thenReturn(const OnBoardingTosState());

      when(
        () => onBoardingTosCubit.setAgreeTerms(
          agreeTerms: any(named: 'agreeTerms'),
        ),
      ).thenAnswer((_) async {});

      when(
        () =>
            onBoardingTosCubit.setReadTerms(readTerms: any(named: 'readTerms')),
      ).thenAnswer((_) async {});

      await tester.pumpApp(
        BlocProvider<OnBoardingTosCubit>(
          create: (context) => onBoardingTosCubit,
          child: OnBoardingTosView(onBoardingTosCubit: onBoardingTosCubit),
        ),
      );
      final agreeCheckbox = find.text('I agree to the terms and conditions.');
      final readCheckbox = find.text('I have read the terms of use.');

      expect(agreeCheckbox, findsOneWidget);
      expect(readCheckbox, findsOneWidget);

      await tester.tap(agreeCheckbox);
      await tester.pumpAndSettle();

      verify(
        () => onBoardingTosCubit.setAgreeTerms(agreeTerms: true),
      ).called(1);

      await tester.tap(readCheckbox);
      await tester.pumpAndSettle();

      verify(() => onBoardingTosCubit.setReadTerms(readTerms: true)).called(1);
    });

    testWidgets('blocks going back from OnBoardingTosPage start page', (
      tester,
    ) async {
      when(
        () => onBoardingTosCubit.state,
      ).thenReturn(const OnBoardingTosState());
      await tester.pumpApp(
        BlocProvider<OnBoardingTosCubit>(
          create: (context) => onBoardingTosCubit,
          child: OnBoardingTosView(onBoardingTosCubit: onBoardingTosCubit),
        ),
      );
      final dynamic appState = tester.state(find.byType(WidgetsApp));
      expect(await appState.didPopRoute(), true);
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosView), findsOneWidget);
    });

    testWidgets('MyElevatedButton press calls onAcceptancePressed', (
      WidgetTester tester,
    ) async {
      when(
        () => onBoardingTosCubit.state,
      ).thenReturn(const OnBoardingTosState());
      await tester.pumpApp(
        BlocProvider<OnBoardingTosCubit>(
          create: (context) => onBoardingTosCubit,
          child: OnBoardingTosView(onBoardingTosCubit: onBoardingTosCubit),
        ),
      );

      when(
        () => onBoardingTosCubit.state,
      ).thenReturn(const OnBoardingTosState(agreeTerms: true, readTerms: true));
      await tester.pump();

      final button = find.text('Start'.toUpperCase());
      expect(button, findsOneWidget);
    });

    testWidgets('renders DisplayTerms', (tester) async {
      when(
        () => onBoardingTosCubit.state,
      ).thenReturn(const OnBoardingTosState());
      await tester.pumpApp(
        BlocProvider<OnBoardingTosCubit>(
          create: (context) => onBoardingTosCubit,
          child: OnBoardingTosView(onBoardingTosCubit: onBoardingTosCubit),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(DisplayTermsofUse), findsOneWidget);
    });

    testWidgets('navigated to DashboardPage when Start is pressed'
        ' when agreeTerms and readTerms are true.', (tester) async {
      when(
        () => onBoardingTosCubit.state,
      ).thenReturn(const OnBoardingTosState(agreeTerms: true, readTerms: true));
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: BlocProvider<OnBoardingTosCubit>(
            create: (context) => onBoardingTosCubit,
            child: OnBoardingTosView(onBoardingTosCubit: onBoardingTosCubit),
          ),
        ),
      );
      await tester.tap(find.text('Start'.toUpperCase()));
      await tester.pumpAndSettle();
      verify(
        () => navigator.pushAndRemoveUntil<void>(
          any(
            that: isRoute<void>(whereName: equals(AltMeStrings.dashBoardPage)),
          ),
          any(that: isA<RoutePredicate>()),
        ),
      ).called(1);
    });
  });
}
