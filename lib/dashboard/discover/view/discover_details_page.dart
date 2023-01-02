import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DiscoverDetailsPage extends StatelessWidget {
  const DiscoverDetailsPage({
    Key? key,
    required this.homeCredential,
    required this.onCallBack,
  }) : super(key: key);

  final HomeCredential homeCredential;
  final VoidCallback onCallBack;

  static Route route({
    required HomeCredential homeCredential,
    required VoidCallback onCallBack,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => DiscoverDetailsPage(
        homeCredential: homeCredential,
        onCallBack: onCallBack,
      ),
      settings: const RouteSettings(name: '/DiscoverDetailsPages'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DiscoverDetailsView(
      homeCredential: homeCredential,
      onCallBack: onCallBack,
    );
  }
}

class DiscoverDetailsView extends StatelessWidget {
  const DiscoverDetailsView({
    Key? key,
    required this.homeCredential,
    required this.onCallBack,
  }) : super(key: key);

  final HomeCredential homeCredential;
  final VoidCallback onCallBack;

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
                                              .caption,
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
          text: l10n.getThisCard,
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
