import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:polygonid/polygonid.dart';

class PolygonIdProofPage extends StatelessWidget {
  const PolygonIdProofPage({
    super.key,
    required this.claimEntity,
  });

  final ClaimEntity claimEntity;

  static Route<dynamic> route({
    required ClaimEntity claimEntity,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => PolygonIdProofPage(
          claimEntity: claimEntity,
        ),
        settings: const RouteSettings(name: '/PolygonIdProofPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final jsonCredential = claimEntity.info;
    final credentialPreview = Credential.fromJson(jsonCredential);
    Widget widget;

    final credentialSubjectType =
        credentialPreview.credentialSubjectModel.credentialSubjectType;

    if (credentialSubjectType == CredentialSubjectType.kycAgeCredential) {
      widget = const CredentialBaseWidget(
        cardBackgroundImagePath: ImageStrings.kycAgeCredentialCard,
        issuerName: '',
        value: '',
      );
    } else if (credentialSubjectType ==
        CredentialSubjectType.kycCountryOfResidence) {
      widget = const CredentialBaseWidget(
        cardBackgroundImagePath: ImageStrings.kycCountryOfResidenceCard,
        issuerName: '',
        value: '',
      );
    } else {
      widget = DefaultCredentialWidget(
        isDiscover: false,
        credentialModel: CredentialModel(
          id: credentialPreview.id,
          image: 'image',
          credentialPreview: credentialPreview,
          shareLink: '',
          data: const <String, dynamic>{},
          jwt: null,
          format: 'ldp_vc',
        ),
      );
    }

    return BasePage(
      useSafeArea: true,
      titleLeading: const BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget,
          const SizedBox(height: 40),
          Image.asset(IconStrings.warning, height: 25),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              l10n.noInformationWillBeSharedFromThisCredentialMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
