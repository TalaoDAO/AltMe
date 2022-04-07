import 'package:altme/app/observer/router_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRouteObserver extends Mock implements MyRouteObserver {}

//https://github.com/roughike/testing-navigation

void main() {
  const String oldRoute = '/oldRoute';
  const String newRoute = '/newRoute';

  final previousRoute = MaterialPageRoute<void>(
    builder: (_) => Container(key: const Key('container1')),
    settings: const RouteSettings(name: oldRoute),
  );

  final route = MaterialPageRoute<void>(
    builder: (_) => Container(key: const Key('container2')),
    settings: const RouteSettings(name: newRoute),
  );

  late NavigatorObserver myRouteObserver;

  setUp(() {
    myRouteObserver = MockRouteObserver();
  });

  group('didPush', () {
    testWidgets('didPush works correctly', (WidgetTester tester) async {
      print('1');
      await tester.pumpWidget(
        MaterialApp(
          home: Container(key: const Key('container3')),
          navigatorObservers: [myRouteObserver],
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case oldRoute:
                return previousRoute;
              case newRoute:
                return route;
            }
          },
        ),
      );

      when(() => myRouteObserver.didPush(route, previousRoute))
          .thenReturn(() {});
      print('2');
      final BuildContext context = tester.element(find.byType(Container));
      print('3');
      Navigator.of(context).pushNamed(newRoute);
      print('4');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('container2')), findsOneWidget);
      print('5');
      verify(() => myRouteObserver.didPush(route, previousRoute)).called(1);
    });
  });
}
