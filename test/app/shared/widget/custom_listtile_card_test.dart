import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomListTileCard displays correctly and responds to tap',
      (WidgetTester tester) async {
    bool triggerred = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomListTileCard(
            title: 'Test Title',
            subTitle: 'Test Subtitle',
            imageAssetPath: 'assets/launcher_icon.png',
            onTap: () {
              triggerred = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);

    expect(find.byIcon(Icons.thumb_up), findsOneWidget);

    await tester.tap(find.byType(ListTile));
    expect(triggerred, isTrue);
  });
}
