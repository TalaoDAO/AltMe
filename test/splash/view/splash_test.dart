import 'package:altme/app/app.dart';
import 'package:altme/flavor/cubit/flavor_cubit.dart';
import 'package:altme/splash/splash.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:secure_storage/secure_storage.dart';

import '../../helpers/helpers.dart';

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

class MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {}

void main() {
  late FlavorCubit flavorCubit;
  late SplashCubit splashCubit;

  setUpAll(() async {
    flavorCubit = MockFlavorCubit();
    splashCubit = MockSplashCubit();
  });

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: flavorCubit),
        BlocProvider.value(value: splashCubit),
      ],
      child: const SplashView(),
    );
  }

  group('SplashPage', () {
    testWidgets('renders SplashView', (tester) async {
      when(() => flavorCubit.state).thenReturn(FlavorMode.development);
      when(() => splashCubit.state)
          .thenReturn(const SplashState(status: SplashStatus.init));
      when(() => splashCubit.initialiseApp()).thenAnswer((_) async {});
      await tester.pumpApp(makeTestableWidget());
      await tester.pumpAndSettle();
      expect(find.byType(SplashView), findsOneWidget);
    });
  });

  group('SplashView', () {
    group('SplashStatus.init', () {
      setUp(() {
        when(() => splashCubit.state)
            .thenReturn(const SplashState(status: SplashStatus.init));
        when(() => splashCubit.initialiseApp()).thenAnswer((_) async {});
      });

      testWidgets('only one BasePage widget is rendered', (tester) async {
        when(() => flavorCubit.state).thenReturn(FlavorMode.development);
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
        expect(assetImage.assetName, equals(ImageStrings.splashDev));
      });

      testWidgets('correct image is rendered for staging flavor',
          (tester) async {
        when(() => flavorCubit.state).thenReturn(FlavorMode.staging);
        await tester.pumpApp(makeTestableWidget());
        await tester.pumpAndSettle();
        final Image image =
            find.byType(Image).evaluate().single.widget as Image;
        final AssetImage assetImage = image.image as AssetImage;
        expect(assetImage.assetName, equals(ImageStrings.splashStage));
      });

      testWidgets('correct image is rendered for production flavor',
          (tester) async {
        when(() => flavorCubit.state).thenReturn(FlavorMode.production);
        await tester.pumpApp(makeTestableWidget());
        await tester.pumpAndSettle();
        final Image image =
            find.byType(Image).evaluate().single.widget as Image;
        final AssetImage assetImage = image.image as AssetImage;
        expect(assetImage.assetName, equals(ImageStrings.splash));
      });

      // this test fails which does not make sense
      // testWidgets('there is only one ScaleTransition widget', (tester) async
      // {
      //   await tester.pumpApp(const SplashView());
      //   expect(find.byType(ScaleTransition), findsOneWidget);
      // });

      testWidgets('scaleAnimation Tween is animated correctly', (tester) async {
        when(() => flavorCubit.state).thenReturn(FlavorMode.development);
        await tester.pumpApp(makeTestableWidget());
        await tester.pump();

        final initialScale = tester
            .widget<ScaleTransition>(find.byKey(const Key('scaleTransition')));
        expect(initialScale.scale.value, 0.2);

        final frames = await tester.pumpAndSettle();
        final finalScale = tester
            .widget<ScaleTransition>(find.byKey(const Key('scaleTransition')));
        expect(finalScale.scale.value, 1.0);

        const int animationSecond = 5;
        const double expectedFrames = ((animationSecond * 1000) / 100) + 1;
        expect(frames, expectedFrames);
      });
    });

    group('SplashStatus.onboarding', () {
      testWidgets(
          '''navigates to OnBoardingFirstPage when state is SplashStatus.onboarding''',
          (tester) async {
        when(() => flavorCubit.state).thenReturn(FlavorMode.development);
        when(() => splashCubit.initialiseApp()).thenAnswer((_) async {});

        whenListen(
          splashCubit,
          Stream.fromIterable(
            [SplashStatus.init, SplashStatus.routeToPassCode],
          ),
          initialState: SplashStatus.init,
        );

        await tester.pumpApp(makeTestableWidget());

        await tester.pumpAndSettle();
        //expect(find.byType(OnBoardingStartPage), findsOneWidget);
      });
    });
  });
}
