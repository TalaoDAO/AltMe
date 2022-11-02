import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class TermsOfUseAndLicences extends StatelessWidget {
  const TermsOfUseAndLicences({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.termsOfUseAndLicenses,
          style: Theme.of(context).textTheme.drawerMenu,
        ),
        const SizedBox(height: 5),
        BackgroundCard(
          color: Theme.of(context).colorScheme.drawerSurface,
          child: Column(
            children: [
              DrawerItem(
                icon: IconStrings.terms,
                title: l10n.termsOfUse,
                onTap: () async {
                  await LaunchUrl.launch(
                    'https://www.arago.app/mentions-legales',
                  );
                },
              ),
              const DrawerItemDivider(),
              DrawerItem(
                icon: IconStrings.terms,
                title: l10n.licenses,
                onTap: () async {
                  await LaunchUrl.launch('https://www.arago.app/');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
