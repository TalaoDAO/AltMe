import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DisplayAltmeContacts extends StatelessWidget {
  const DisplayAltmeContacts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        InkWell(
          onTap: () async {
            await LaunchUrl.launch(Urls.appContactWebsiteUrl);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.appContactWebsite} : ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  AltMeStrings.appContactWebsiteName,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).colorScheme.markDownA,
                        decoration: TextDecoration.underline,
                      ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            await LaunchUrl.launch('mailto:${AltMeStrings.appContactMail}');
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.personalMail} : ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  AltMeStrings.appContactMail,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).colorScheme.markDownA,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
