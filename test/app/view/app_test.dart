// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:altme/app/app.dart';
import 'package:altme/theme/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('App', () {
    test('default flavor is FlavorMode.production', () async {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({'test': 1});
      // Creating an instance of ThemeRepository that will invoke the _init()
      // method and populate the stream controller in the repository.
      final themeRepository = ThemeRepository(
        sharedPreferences: await SharedPreferences.getInstance(),
      );

      expect(
          App(
            themeRepository: themeRepository,
          ).flavorMode,
          FlavorMode.production);
    });

    // testWidgets('renders SplashPage', (tester) async {
    //   await tester.pumpWidget(const App());
    //   await tester.pumpAndSettle();
    //   expect(find.byType(SplashPage), findsOneWidget);
    // });
  });
}
