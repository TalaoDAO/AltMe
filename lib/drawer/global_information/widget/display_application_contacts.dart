import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayAltmeContacts extends StatelessWidget {
  const DisplayAltmeContacts({
    Key? key,
  }) : super(key: key);

  Future<void> _launchURL(String _url) async =>
      await canLaunchUrl(Uri.parse(_url))
          ? await launchUrl(Uri.parse(_url))
          : throw Exception('Could not launch $_url');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        InkWell(
          onTap: () => _launchURL(Urls.appContactWebsiteUrl),
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
          onTap: () => _launchURL('mailto:${AltMeStrings.appContactMail}'),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.personalMail} : ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  'contact@altme.io',
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
