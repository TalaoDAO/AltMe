import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DiscoverDetailsPage extends StatelessWidget {
  const DiscoverDetailsPage({
    super.key,
    required this.homeCredential,
    required this.onCallBack,
    required this.buttonText,
  });

  final HomeCredential homeCredential;
  final VoidCallback onCallBack;
  final String buttonText;

  static Route<dynamic> route({
    required HomeCredential homeCredential,
    required VoidCallback onCallBack,
    required String buttonText,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => DiscoverDetailsPage(
        homeCredential: homeCredential,
        onCallBack: onCallBack,
        buttonText: buttonText,
      ),
      settings: const RouteSettings(name: '/DiscoverDetailsPages'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DiscoverDetailsView(
      homeCredential: homeCredential,
      onCallBack: onCallBack,
      buttonText: buttonText,
    );
  }
}

class DiscoverDetailsView extends StatelessWidget {
  const DiscoverDetailsView({
    super.key,
    required this.homeCredential,
    required this.onCallBack,
    required this.buttonText,
  });

  final HomeCredential homeCredential;
  final VoidCallback onCallBack;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.cardDetails,
      scrollView: false,
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
                      child: AspectRatio(
                        aspectRatio: Sizes.credentialAspectRatio,
                        child: CredentialImage(
                          image: homeCredential.image!,
                          child: homeCredential.dummyDescription == null
                              ? null
                              : CustomMultiChildLayout(
                                  delegate: DummyCredentialItemDelegate(
                                    position: Offset.zero,
                                  ),
                                  children: [
                                    LayoutId(
                                      id: 'dummyDesc',
                                      child: FractionallySizedBox(
                                        widthFactor: 0.85,
                                        heightFactor: 0.36,
                                        child: MyText(
                                          homeCredential.dummyDescription!
                                              .getMessage(
                                            context,
                                            homeCredential.dummyDescription!,
                                          ),
                                          maxLines: 3,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    _buildDetailsFields(context, l10n),
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
        child: MyGradientButton(
          onPressed: homeCredential.credentialSubjectType.isDisabled
              ? null
              : onCallBack,
          text: buttonText,
        ),
      ),
    );
  }

  Widget _buildDetailsFields(BuildContext context, AppLocalizations l10n) {
    if (homeCredential.credentialSubjectType.isDisabled) {
      return DiscoverDynamicDetial(
        title: l10n.credentialManifestDescription,
        value: l10n.soonCardDescription,
      );
    }
    return Column(
      children: [
        if (homeCredential.websiteGameLink != null)
          DiscoverDynamicDetial(
            title: l10n.websiteGame,
            value: homeCredential.websiteGameLink!,
            format: AltMeStrings.uri,
          ),
        if (homeCredential.whyGetThisCard != null)
          DiscoverDynamicDetial(
            title: l10n.whyGetThisCard,
            value: homeCredential.whyGetThisCard!.getMessage(
              context,
              homeCredential.whyGetThisCard!,
            ),
          ),
        if (homeCredential.expirationDateDetails != null)
          DiscoverDynamicDetial(
            title: l10n.expirationDate,
            value: homeCredential.expirationDateDetails!.getMessage(
              context,
              homeCredential.expirationDateDetails!,
            ),
          ),
        if (homeCredential.howToGetIt != null)
          DiscoverDynamicDetial(
            title: l10n.howToGetIt,
            value: homeCredential.howToGetIt!.getMessage(
              context,
              homeCredential.howToGetIt!,
            ),
          ),
      ],
    );
  }
}
