import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MyRouteObserver myRouteObserver;

  setUpAll(() {
    myRouteObserver = MyRouteObserver();
  });

  group('didPush', () {
    testWidgets('didPush works correctly', (WidgetTester tester) async {
      final oldRoute = MaterialPageRoute<void>(builder: (_) => Container());
      final newRoute = MaterialPageRoute<void>(builder: (_) => Container());
      await tester.pumpWidget(
        MaterialApp(
          home: Container(),
          navigatorObservers: [myRouteObserver],
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/oldRoute':
                return oldRoute;
              case '/newRoute':
                return newRoute;
            }
          },
        ),
      );
      final BuildContext context = tester.element(find.byType(Container));
      await Navigator.of(context).pushNamed('newRoute');
      await tester.pumpAndSettle();
      verify(() => myRouteObserver.didPush(newRoute, oldRoute)).called(1);
    });
  });
}
