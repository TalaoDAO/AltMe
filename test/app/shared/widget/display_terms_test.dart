import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('Display Terms', () {
    testWidgets('renders spinner', (tester) async {
      await tester.pumpApp(const DisplayTerms());
      expect(find.byType(DisplayTerms), findsOneWidget);
    });

    testWidgets('log is instantiated', (tester) async {
      await tester.pumpApp(const DisplayTerms());
      final dynamic appState = tester.state(find.byType(DisplayTerms));
      expect(appState.log, isNotNull);
    });

    testWidgets('path of privacy policy matches with device language',
        (tester) async {
      await tester.pumpApp(const DisplayTerms());
      final dynamic appState = tester.state(find.byType(DisplayTerms));
      appState.setPath('it');
      expect(appState.path, 'assets/privacy/privacy_it.md');
    });

    testWidgets('returns english privacy policy for empty string',
        (tester) async {
      await tester.pumpApp(const DisplayTerms());
      final dynamic appState = tester.state(find.byType(DisplayTerms));
      appState.setPath('');
      expect(appState.path, 'assets/privacy/privacy_en.md');
    });
  });
}
