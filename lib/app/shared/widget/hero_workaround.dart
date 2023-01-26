import 'package:flutter/material.dart';

class HeroFix extends StatelessWidget {
  const HeroFix({
    super.key,
    required this.tag,
    required this.child,
  });

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) => Hero(
        tag: tag,
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) =>
            Material(
          key: const Key('shuttleKey'),
          color: Colors.transparent,
          child: toHeroContext.widget,
        ),
        child: child,
      );
}
