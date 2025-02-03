import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DidMenu extends StatelessWidget {
  const DidMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ssiMenu/didMenu'),
      builder: (_) => const DidMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DidView();
  }
}

class DidView extends StatelessWidget {
  const DidView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const BackLeadingButton(
                  padding: EdgeInsets.zero,
                ),
                WalletLogo(
                  height: 90,
                  width: MediaQuery.of(context).size.shortestSide * 0.5,
                  showPoweredBy: true,
                ),
                ListView.builder(
                  itemCount: DidKeyType.values.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    final didKeyType = DidKeyType.values[index];

                    if (didKeyType == DidKeyType.jwtClientAttestation) {
                      return Container();
                    }

                    /// there is no new key for EBSI V4
                    if (didKeyType == DidKeyType.ebsiv4) {
                      return Container();
                    }

                    final title = didKeyType.getTitle(l10n);
                    return DrawerItem(
                      title: title,
                      onTap: () {
                        Navigator.of(context).push<void>(
                          ManageDidPage.route(
                            didKeyType: didKeyType,
                          ),
                        );
                      },
                    );
                  },
                ),
                DrawerItem(
                  title: l10n.jwkThumbprintP256Key,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      JWKThumbprintP256KeyPage.route(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
