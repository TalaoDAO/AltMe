import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

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
      title: l10n.cardDetails,
      scrollView: false,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      body: BackgroundCard(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: DummyCredentialImage(
                        credentialSubjectType:
                            dummyCredential.credentialSubjectType,
                        image: dummyCredential.image,
                        displayExternalIssuer: dummyCredential.display,
                      ),
                    ),
                    DetailFields(dummyCredential: dummyCredential),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(
          Sizes.spaceSmall,
        ),
        child: MyElevatedButton(
          onPressed: onCallBack,
          text: buttonText,
        ),
      ),
    );
  }
}

class DetailFields extends StatelessWidget {
  const DetailFields({
    super.key,
    required this.dummyCredential,
  });

  final DiscoverDummyCredential dummyCredential;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dummyCredential.websiteLink != null ||
            dummyCredential.websiteLinkExtern != null)
          DiscoverDynamicDetial(
            title: l10n.website,
            value: dummyCredential.websiteLinkExtern ??
                dummyCredential.websiteLink!,
            format: AltMeStrings.uri,
          ),
        if (dummyCredential.longDescription != null ||
            dummyCredential.longDescriptionExtern != null)
          DiscoverDynamicDetial(
            title: dummyCredential.credentialSubjectType ==
                    CredentialSubjectType.defaultCredential
                ? dummyCredential.display?.name
                : dummyCredential.credentialSubjectType.title,
            value: dummyCredential.longDescriptionExtern ??
                dummyCredential.longDescription!.getMessage(
                  context,
                  dummyCredential.longDescription!,
                ),
          ),
        if (dummyCredential.whyGetThisCard != null ||
            dummyCredential.whyGetThisCardExtern != null)
          DiscoverDynamicDetial(
            title: l10n.whyGetThisCard,
            value: dummyCredential.whyGetThisCardExtern ??
                dummyCredential.whyGetThisCard!.getMessage(
                  context,
                  dummyCredential.whyGetThisCard!,
                ),
          ),
        if (dummyCredential.expirationDateDetails != null ||
            dummyCredential.expirationDateDetailsExtern != null)
          DiscoverDynamicDetial(
            title: l10n.expirationDate,
            value: dummyCredential.expirationDateDetailsExtern ??
                dummyCredential.expirationDateDetails!.getMessage(
                  context,
                  dummyCredential.expirationDateDetails!,
                ),
          ),
        if (dummyCredential.howToGetIt != null ||
            dummyCredential.howToGetItExtern != null)
          DiscoverDynamicDetial(
            title: l10n.howToGetIt,
            value: dummyCredential.howToGetItExtern ??
                dummyCredential.howToGetIt!.getMessage(
                  context,
                  dummyCredential.howToGetIt!,
                ),
          ),
      ],
    );
  }
}
