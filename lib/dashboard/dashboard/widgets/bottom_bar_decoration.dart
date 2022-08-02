import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class BottomBarDecoration extends StatelessWidget {
  const BottomBarDecoration({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 2),
      child: BackgroundCard(
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}
