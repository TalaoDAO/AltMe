import 'package:flutter/material.dart';

class TabBarViewMainContentElementHeader extends StatelessWidget {
  const TabBarViewMainContentElementHeader({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryVariant,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 3,
            left: 3,
            right: 3,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.ac_unit_rounded),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
