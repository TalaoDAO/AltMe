import 'dart:async';

import 'package:altme/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RightToLeftRoute transition test', (WidgetTester tester) async {
    const fromWidget = Scaffold(body: Center(child: Text('From Screen')));
    const toWidget = Scaffold(body: Center(child: Text('To Screen')));

    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: fromWidget,
      ),
    );

    expect(find.text('From Screen'), findsOneWidget);
    expect(find.text('To Screen'), findsNothing);

    unawaited(
      navigatorKey.currentState!
          .push(RightToLeftRoute(builder: (context) => toWidget)),
    );

    await tester.pumpAndSettle();

    expect(find.text('From Screen'), findsNothing);
    expect(find.text('To Screen'), findsOneWidget);
  });
}
