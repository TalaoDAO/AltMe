import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/polygon_id/polygon_id.dart';

import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PolygonIdCredentialOfferPage extends StatelessWidget {
  const PolygonIdCredentialOfferPage({
    super.key,
    required this.uri,
  });

  final Uri uri;

  static Route<dynamic> route(Uri uri) => MaterialPageRoute<void>(
        builder: (context) => PolygonIdCredentialOfferPage(uri: uri),
        settings: const RouteSettings(name: '/PolygonIdCredentialOffer'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final polygonIdCubitState = context.read<PolygonIdCubit>().state;

    return BasePage(
      title: l10n.credentialReceiveTitle,
      useSafeArea: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              l10n.wouldYouLikeToAcceptThisCredentialsFromThisOrganisation,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 30),
            ListView.builder(
              itemCount: polygonIdCubitState.claims!.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int i) {
                final jsonCredential = polygonIdCubitState.claims![i].info;
                final credentialPreview = Credential.fromJson(jsonCredential);

                final DisplayMapping? titleDisplayMapping = polygonIdCubitState
                    .credentialManifests![i]
                    .outputDescriptors
                    ?.first
                    .display
                    ?.title;

                var title = '';

                if (titleDisplayMapping is DisplayMappingText) {
                  title = titleDisplayMapping.text;
                }

                if (titleDisplayMapping is DisplayMappingPath) {
                  title = titleDisplayMapping.fallback ?? '';
                }

                final DisplayMapping? subTitleDisplayMapping =
                    polygonIdCubitState.credentialManifests?[i]
                        .outputDescriptors?.first.display?.subtitle;

                var subTitle = '';

                if (subTitleDisplayMapping is DisplayMappingText) {
                  subTitle = subTitleDisplayMapping.text;
                }

                if (subTitleDisplayMapping is DisplayMappingPath) {
                  subTitle = subTitleDisplayMapping.fallback ?? '';
                }

                Widget widget;

                final credentialSubjectType = credentialPreview
                    .credentialSubjectModel.credentialSubjectType;

                if (credentialSubjectType ==
                    CredentialSubjectType.kycAgeCredential) {
                  widget = const CredentialBaseWidget(
                    cardBackgroundImagePath: ImageStrings.kycAgeCredentialCard,
                    issuerName: '',
                    value: '',
                  );
                } else if (credentialSubjectType ==
                    CredentialSubjectType.kycCountryOfResidence) {
                  widget = const CredentialBaseWidget(
                    cardBackgroundImagePath:
                        ImageStrings.kycCountryOfResidenceCard,
                    issuerName: '',
                    value: '',
                  );
                } else if (credentialSubjectType ==
                    CredentialSubjectType.proofOfTwitterStats) {
                  widget = const CredentialBaseWidget(
                    cardBackgroundImagePath: ImageStrings.twitterStatsCard,
                    issuerName: '',
                    value: '',
                  );
                } else if (credentialSubjectType ==
                    CredentialSubjectType.civicPassCredential) {
                  widget = CredentialBaseWidget(
                    title: title,
                    cardBackgroundImagePath: ImageStrings.civicPassCard,
                    issuerName: polygonIdCubitState
                        .credentialManifests?[i].issuedBy?.name,
                    value: subTitle,
                  );
                } else {
                  widget = CredentialBaseWidget(
                    title: title,
                    cardBackgroundImagePath: ImageStrings.defaultCard,
                    issuerName: polygonIdCubitState
                        .credentialManifests?[i].issuedBy?.name,
                    value: subTitle,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: widget,
                );
              },
            ),
          ],
        ),
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyElevatedButton(
              text: l10n.accept,
              onPressed: () async {
                await securityCheck(
                  context: context,
                  title: l10n.typeYourPINCodeToAuthenticate,
                  localAuthApi: LocalAuthApi(),
                  onSuccess: () {
                    context.read<PolygonIdCubit>().addPolygonIdCredentials(
                          qrCodeScanCubit: context.read<QRCodeScanCubit>(),
                          uri: uri,
                        );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            MyOutlinedButton(
              verticalSpacing: 20,
              borderRadius: 20,
              text: l10n.cancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
