import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('Display Terms', () {
    testWidgets('renders spinner', (tester) async {
      await tester.pumpApp(const DisplayTermsofUse());
      expect(find.byType(DisplayTermsofUse), findsOneWidget);
    });

    testWidgets('log is instantiated', (tester) async {
      await tester.pumpApp(const DisplayTermsofUse());
      final dynamic appState = tester.state(find.byType(DisplayTermsofUse));
      expect(appState.log, isNotNull);
    });

    testWidgets('returns privacy policies and terms for empty string',
        (tester) async {
      await tester.pumpApp(const DisplayTermsofUse());
      final dynamic appState = tester.state(find.byType(DisplayTermsofUse));
      final list = await appState.getBodyData('');
      expect(list, isA<List<String>>());
    });
  });
}
