import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DrawerItemDivider extends StatelessWidget {
  const DrawerItemDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.borderColor,
            width: 0.2,
          ),
        ),
      ),
    );
  }
}
