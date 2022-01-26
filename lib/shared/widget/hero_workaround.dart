import 'package:flutter/material.dart';

class HeroFix extends StatelessWidget {
  final String tag;
  final Widget child;

  const HeroFix({
    Key? key,
    required this.tag,
    required this.child,
  }) : super(key: key);

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
          color: Colors.transparent,
          child: toHeroContext.widget,
        ),
        child: child,
      );
}
