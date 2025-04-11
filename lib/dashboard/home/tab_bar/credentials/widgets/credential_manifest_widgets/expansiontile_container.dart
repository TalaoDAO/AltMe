import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class ExpansionTileContainer extends StatelessWidget {
  const ExpansionTileContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.07),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
          dividerColor:
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.07),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          colorScheme: ColorScheme.dark(
            primary: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        child: child,
      ),
    );
  }
}
