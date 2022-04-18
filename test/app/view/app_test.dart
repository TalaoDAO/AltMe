// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:altme/app/app.dart';
import 'package:altme/splash/view/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    test('default flavor is FlavorMode.production', () async {
      expect(const App().flavorMode, FlavorMode.production);
    });

    testWidgets('renders SplashPage', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(SplashPage), findsOneWidget);
    });
  });
}
