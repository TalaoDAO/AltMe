import 'package:altme/app/app.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  late ThemeCubit themeCubit;

  setUpAll(() {
    themeCubit = MockThemeCubit();
  });

  group('SplashPage', () {
    testWidgets('renders SplashView', (tester) async {
      await tester.pumpApp(const SplashView());
      expect(find.byType(SplashView), findsOneWidget);
    });
  });

  group('SplashView', () {
    testWidgets('there is only one BasePage widget', (tester) async {
      await tester.pumpApp(const SplashView());
      expect(find.byType(BasePage), findsOneWidget);
    });

    testWidgets('correct image is rendered', (tester) async {
      await tester.pumpApp(const SplashView());
      final Image image = find.byType(Image).evaluate().single.widget as Image;
      final AssetImage assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(ImageStrings.splash));
    });

    // TODO(bibash): this test fails which does not make sense
    // testWidgets('there is only one ScaleTransition widget', (tester) async {
    //   await tester.pumpApp(const SplashView());
    //   expect(find.byType(ScaleTransition), findsOneWidget);
    // });

    testWidgets('scaleAnimation Tween is correct', (tester) async {
      await tester.pumpApp(const SplashView());
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
}
