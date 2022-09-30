import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class NetworkAndRegistriesItems extends StatelessWidget {
  const NetworkAndRegistriesItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.networkAndRegistries,
          style: Theme.of(context).textTheme.drawerMenu,
        ),
        const SizedBox(height: 5),
        BackgroundCard(
          color: Theme.of(context).colorScheme.drawerSurface,
          child: Column(
            children: [
              // DrawerItem(
              //   icon: IconStrings.cloudAdd,
              //   title: l10n.chooseNetwork,
              //   onTap: () async {
              //     await Navigator.of(context)
              //         .push<void>(ManageNetworkPage.route());
              //   },
              // ),
              // const DrawerItemDivider(),
              DrawerItem(
                icon: IconStrings.issuer,
                title: l10n.chooseRegistry,
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
