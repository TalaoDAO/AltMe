import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class BottomBarPage extends StatelessWidget {
  const BottomBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 2),
      child: BackgroundCard(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomBarItem(
              icon: IconStrings.story,
              text: l10n.infos,
              onPressed: () {
                Navigator.of(context)
                    .push<void>(GeneralInformationPage.route());
              },
            ),
            BottomBarItem(
              icon: IconStrings.profile,
              text: l10n.profile,
              onPressed: () {
                Navigator.of(context).push<void>(ProfilePage.route());
              },
            ),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            BottomBarItem(
              icon: IconStrings.searchNormal,
              text: l10n.search,
              onPressed: () {},
            ),
            BottomBarItem(
              icon: IconStrings.save,
              text: l10n.save,
              onPressed: () {
                Navigator.of(context).push<void>(BackupCredentialPage.route());
              },
            ),
          ],
        ),
      ),
    );
  }
}
