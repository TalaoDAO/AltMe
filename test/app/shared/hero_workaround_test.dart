import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Hero Workaround', () {
    testWidgets('flightShuttleBuilder is rendered', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ListView(
              children: <Widget>[
                Builder(
                  builder: (BuildContext context) {
                    return TextButton(
                      child: const Hero(tag: 'tag', child: Text('I am button')),
                      onPressed: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return const Material(
                              child: HeroFix(
                                tag: 'tag',
                                child: Text('I am new Page button'),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('I am button'), findsOneWidget);

      await tester.tap(find.text('I am button'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text('I am button'), findsNothing);
      expect(find.byKey(const Key('shuttleKey')), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('I am new Page button'), findsOneWidget);
      expect(find.byKey(const Key('shuttleKey')), findsNothing);
    });
  });
}
