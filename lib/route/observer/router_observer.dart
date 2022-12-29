import 'package:altme/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Ignoring this part which is already tested in Flutter framework.
/// If we add some real functionality here in the future, the new function
/// itself should be tested.

// coverage:ignore-start
class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  MyRouteObserver(this.context) : super();

  final BuildContext context;

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPush(route!, previousRoute);
    if (route is PageRoute) sendScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) sendScreenView(newRoute);
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPop(route!, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      sendScreenView(previousRoute);
    }
  }

  void sendScreenView(PageRoute<dynamic> route) {
    final String? routeName = route.settings.name;
    context.read<RouteCubit>().setCurrentScreen(routeName);
  }
}
// coverage:ignore-end
