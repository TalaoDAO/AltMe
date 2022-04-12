import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ToolTip Text', () {
    testWidgets('does not renders CustomAppBar when title is null',
        (tester) async {
      await tester.pumpApp(
        const TooltipText(
          text: 'I am text',
          tag: null,
        ),
      );
      expect(find.byType(HeroFix), findsNothing);
    });

    testWidgets('does not renders CustomAppBar when title is empty',
        (tester) async {
      await tester.pumpApp(
        const TooltipText(
          text: 'I am text',
          tag: '',
        ),
      );
      expect(find.byType(HeroFix), findsNothing);
    });

    testWidgets('does not renders CustomAppBar when title is provided',
        (tester) async {
      await tester.pumpApp(
        const TooltipText(
          text: 'I am text',
          tag: 'I am tag',
        ),
      );
      expect(find.byType(HeroFix), findsOneWidget);
    });
  });
}
