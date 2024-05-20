import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('AddAccountButton', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: AddAccountButton(onPressed: () {}),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
    });

    testWidgets('displays correct text', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: AddAccountButton(onPressed: () {}),
        ),
      );

      expect(find.text('Add Account'), findsOneWidget);
      expect(find.text('Create or import a new account.'), findsOneWidget);
    });

    testWidgets('triggers onPressed callback when tapped', (tester) async {
      var click = false;

      await tester.pumpApp(
        Scaffold(
          body: AddAccountButton(
            onPressed: () {
              click = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(click, true);
    });
  });
}
