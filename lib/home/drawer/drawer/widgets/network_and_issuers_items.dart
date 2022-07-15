import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class NetworkAnIssuersItems extends StatelessWidget {
  const NetworkAnIssuersItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.networkAndIssuers,
          style: Theme.of(context).textTheme.drawerMenu,
        ),
        const SizedBox(height: 5),
        BackgroundCard(
          color: Theme.of(context).colorScheme.drawerSurface,
          child: Column(
            children: [
              DrawerItem(
                icon: IconStrings.cloudAdd,
                title: l10n.manageNetwork,
                onTap: () async {
                  await Navigator.of(context)
                      .push<void>(ManageNetworkPage.route());
                },
              ),
              const DrawerItemDivider(),
              DrawerItem(
                icon: IconStrings.issuer,
                title: l10n.manageIssuerRegistry,
                onTap: () async {
                  await Navigator.of(context)
                      .push<void>(ManageIssuersRegistryPage.route());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
