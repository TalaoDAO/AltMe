import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ExpansionTileContainer extends StatelessWidget {
  const ExpansionTileContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
          dividerColor: Theme.of(context).colorScheme.surfaceContainer,
          splashColor: Theme.of(context).colorScheme.transparent,
          highlightColor: Theme.of(context).colorScheme.transparent,
          colorScheme: ColorScheme.dark(
            primary: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        child: child,
      ),
    );
  }
}
