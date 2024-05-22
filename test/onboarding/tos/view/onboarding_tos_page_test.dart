import 'package:altme/app/app.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class MockOnBoardingTosCubit extends MockCubit<OnBoardingTosState>
    implements OnBoardingTosCubit {}

void main() {
  group('OnBoarding Terms Page', () {
    late MockOnBoardingTosCubit onBoardingTosCubit;

    setUpAll(() {
      onBoardingTosCubit = MockOnBoardingTosCubit();
      when(() => onBoardingTosCubit.state)
          .thenReturn(const OnBoardingTosState());
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<void>(OnBoardingTosPage.route());
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    testWidgets('renders OnBoardingTosPage', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: onBoardingTosCubit,
          child: const OnBoardingTosPage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosView), findsOneWidget);
    });

    testWidgets('nothing happens when button is pressed', (tester) async {
      await tester.pumpApp(const OnBoardingTosPage());
      await tester.tap(find.byType(MyGradientButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    // testWidgets('checkboxes toggle state', (WidgetTester tester) async {
    //   when(() => onBoardingTosCubit.setAgreeTerms(
    //       agreeTerms: any(named: 'agreeTerms'))).thenAnswer((_) async {});
    //   when(() => onBoardingTosCubit.setReadTerms(
    //       readTerms: any(named: 'readTerms'))).thenAnswer((_) async {});

    //   await tester.pumpApp(
    //     BlocProvider<MockOnBoardingTosCubit>(
    //       create: (_) => onBoardingTosCubit,
    //       child: const OnBoardingTosPage(),
    //     ),
    //   );

    //   final agreeCheckbox = find.text('I agree to the terms and conditions.');
    //   final readCheckbox = find.text('I have read the terms of use.');

    //   expect(agreeCheckbox, findsOneWidget);
    //   expect(readCheckbox, findsOneWidget);

    //   await tester.tap(agreeCheckbox);
    //   await tester.pumpAndSettle();

    //   verify(() => onBoardingTosCubit.setAgreeTerms(agreeTerms: true))
    //       .called(1);
    // });

    testWidgets('blocks going back from OnBoardingTosPage start page',
        (tester) async {
      await tester.pumpApp(const OnBoardingTosPage());
      final dynamic appState = tester.state(find.byType(WidgetsApp));
      expect(await appState.didPopRoute(), true);
      await tester.pumpAndSettle();
      expect(find.byType(OnBoardingTosPage), findsOneWidget);
    });

    testWidgets(
      'MyGradientButton press calls onAcceptancePressed',
      (WidgetTester tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: onBoardingTosCubit,
            child: const OnBoardingTosPage(),
          ),
        );

        when(() => onBoardingTosCubit.state).thenReturn(
          const OnBoardingTosState(
            agreeTerms: true,
            readTerms: true,
          ),
        );
        await tester.pump();

        final button = find.text('Start'.toUpperCase());
        expect(button, findsOneWidget);
      },
    );

    testWidgets('renders DisplayTerms', (tester) async {
      await tester.pumpApp(const OnBoardingTosPage());
      await tester.pumpAndSettle();
      expect(find.byType(DisplayTermsofUse), findsOneWidget);
    });
  });
}
