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

    /// we disabled display of privacy asset in phone language for now
    testWidgets('path of privacy policy matches with device language',
        (tester) async {
      await tester.pumpApp(const DisplayTermsofUse());
      final dynamic appState = tester.state(find.byType(DisplayTermsofUse));
      appState.setPath('it');
      expect(appState.path, 'assets/privacy/privacy_en.md');
    });

    testWidgets('returns english privacy policy for empty string',
        (tester) async {
      await tester.pumpApp(const DisplayTermsofUse());
      final dynamic appState = tester.state(find.byType(DisplayTermsofUse));
      appState.setPath('');
      expect(appState.path, 'assets/privacy/privacy_en.md');
    });
  });
}
