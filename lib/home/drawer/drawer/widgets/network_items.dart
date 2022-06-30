import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class NetworkItems extends StatelessWidget {
  const NetworkItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.network,
          style: Theme.of(context).textTheme.drawerMenu,
        ),
        const SizedBox(height: 5),
        BackgroundCard(
          color: Theme.of(context).colorScheme.drawerSurface,
          child: Column(
            children: [
              DrawerItem(
                icon: IconStrings.userRound,
                title: l10n.manageNetwork,
                trailing: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () async {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
