import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  testWidgets('ErrorView displays message and try again button',
      (WidgetTester tester) async {
    const testMessage = 'An error occurred';
    bool wasButtonTapped = false;

    await tester.pumpApp(
      ErrorView(
        message: testMessage,
        onTap: () {
          wasButtonTapped = true;
        },
      ),
    );

    expect(find.text(testMessage), findsOneWidget);

    expect(find.byType(MyOutlinedButton), findsOneWidget);

    await tester.tap(find.byType(MyOutlinedButton));
    await tester.pumpAndSettle();

    expect(wasButtonTapped, isTrue);
  });
}
