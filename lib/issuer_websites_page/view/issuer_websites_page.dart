import 'package:altme/app/app.dart';
import 'package:altme/issuer_websites_page/widget/kyc_button.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class IssuerWebsitesPage extends StatelessWidget {
  const IssuerWebsitesPage(
    this.issuerFilter, {
    Key? key,
  }) : super(key: key);

  final String? issuerFilter;

  static Route route(String? issuerType) => MaterialPageRoute<void>(
        builder: (context) => IssuerWebsitesPage(issuerType),
        settings: const RouteSettings(name: '/issuerWebsitesPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.issuerWebsitesTitle,
      titleLeading: const BackLeadingButton(),
      body: Column(
        children: [
          BaseButton.primary(
            context: context,
            onPressed: () async {
              await LaunchUrl.launch(Urls.emailPassUrl);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.language),
                ),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(l10n.emailPassCredential),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BaseButton.primary(
            context: context,
            onPressed: () async {
              await LaunchUrl.launch(Urls.phonePassUrl);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.phone),
                ),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(l10n.phonePassCredential),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const KYCButton(),
        ],
      ),
    );
  }
}
