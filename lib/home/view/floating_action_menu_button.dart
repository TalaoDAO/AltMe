import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/app/view/icon_theme_switch.dart';

class FloatingActionMenu extends StatelessWidget {
  const FloatingActionMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FabCircularMenu(
        ringDiameter: 300,
        ringWidth: 60,
        ringColor: Theme.of(context).colorScheme.secondaryVariant,
        fabColor: Theme.of(context).colorScheme.secondaryVariant,
        fabOpenIcon: const Icon(Icons.open_in_browser),
        children: <Widget>[
          const IconThemeSwitch(),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              if (kDebugMode) {
                print('Home');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.credit_card),
            onPressed: () {
              if (kDebugMode) {
                print('Favorite');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (kDebugMode) {
                print('Favorite');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.swap_calls),
            onPressed: () {
              if (kDebugMode) {
                print('Favorite');
              }
            },
          ),
        ],
      ),
    );
  }
}
