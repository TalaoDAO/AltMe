import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:wallet_ui/wallet_ui.dart';

class DiscoverDetailsPage extends StatelessWidget {
  const DiscoverDetailsPage({
    super.key,
    required this.dummyCredential,
    required this.onCallBack,
    required this.buttonText,
  });

  final DiscoverDummyCredential dummyCredential;
  final VoidCallback onCallBack;
  final String buttonText;

  static Route<dynamic> route({
    required DiscoverDummyCredential dummyCredential,
    required VoidCallback onCallBack,
    required String buttonText,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => DiscoverDetailsPage(
        dummyCredential: dummyCredential,
        onCallBack: onCallBack,
        buttonText: buttonText,
      ),
      settings: const RouteSettings(name: '/DiscoverDetailsPages'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DiscoverDetailsView(
      dummyCredential: dummyCredential,
      onCallBack: onCallBack,
      buttonText: buttonText,
    );
  }
}

class DiscoverDetailsView extends StatelessWidget {
  const DiscoverDetailsView({
    super.key,
    required this.dummyCredential,
    required this.onCallBack,
    required this.buttonText,
  });

  final DiscoverDummyCredential dummyCredential;
  final VoidCallback onCallBack;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      backgroundColor: context.walletColors.backgroundAlternative,
      appBarBackgroundColor: context.walletColors.backgroundAlternative,
      title: l10n.cardDetails,
      scrollView: false,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.symmetric(horizontal: WalletSpacing.m),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: WalletSpacing.m,
          children: [
            AspectRatio(
              aspectRatio: Sizes.credentialAspectRatio,
              child: DummyCredentialImage(
                credentialSubjectType: dummyCredential.credentialSubjectType,
                image: dummyCredential.image,
                displayExternalIssuer: dummyCredential.display,
              ),
            ),
            DetailFields(dummyCredential: dummyCredential),
          ],
        ),
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(WalletSpacing.m),
        child: WalletButton(
          label: buttonText,
          onPressed: onCallBack,
          expand: true,
        ),
      ),
    );
  }
}

class DetailFields extends StatelessWidget {
  const DetailFields({super.key, required this.dummyCredential});

  final DiscoverDummyCredential dummyCredential;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final website =
        dummyCredential.websiteLinkExtern ?? dummyCredential.websiteLink;
    final longDescription =
        dummyCredential.longDescriptionExtern ??
        dummyCredential.longDescription?.getMessage(
          context,
          dummyCredential.longDescription!,
        );
    final whyGetThisCard =
        dummyCredential.whyGetThisCardExtern ??
        dummyCredential.whyGetThisCard?.getMessage(
          context,
          dummyCredential.whyGetThisCard!,
        );
    final expirationDate =
        dummyCredential.expirationDateDetailsExtern ??
        dummyCredential.expirationDateDetails?.getMessage(
          context,
          dummyCredential.expirationDateDetails!,
        );
    final howToGetIt =
        dummyCredential.howToGetItExtern ??
        dummyCredential.howToGetIt?.getMessage(
          context,
          dummyCredential.howToGetIt!,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: WalletSpacing.m,
      children: [
        if (website != null)
          WalletEntityCard(
            label: l10n.website,
            name: l10n.link,
            trailing: const WalletIcon(WalletIconStrings.arrowForward),
            onTap: () => LaunchUrl.launch(website),
          ),
        if (longDescription != null)
          WalletDescriptionCard(
            title: dummyCredential.discoverName,
            description: longDescription,
          ),
        if (whyGetThisCard != null)
          WalletDescriptionCard(
            title: l10n.whyGetThisCard,
            description: whyGetThisCard,
          ),
        if (expirationDate != null)
          WalletDescriptionCard(
            title: l10n.expirationDate,
            description: expirationDate,
          ),
        if (howToGetIt != null)
          WalletDescriptionCard(
            title: l10n.howToGetIt,
            description: howToGetIt,
          ),
      ],
    );
  }
}
