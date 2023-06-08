import 'dart:math';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
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

    var credentialSubjectType = CredentialSubjectType.defaultCredential;

    for (final element in CredentialSubjectType.values) {
      if (claimEntity.type == element.name) {
        credentialSubjectType = element;
        break;
      }
    }

    Widget widget;

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
      widget = CredentialContainer(
        child: AspectRatio(
          aspectRatio: Sizes.credentialAspectRatio,
          child: DecoratedBox(
            decoration: BaseBoxDecoration(
              color: Theme.of(context).colorScheme.credentialBackground,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff0B67C5),
                  Color(0xff200072),
                ],
              ),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1,
              anchors: const <Alignment>[],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              separateUppercaseWords(claimEntity.type),
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              l10n.proof,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.grey.withOpacity(0.9),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
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
              style: Theme.of(context).textTheme.subMessage,
            ),
          ),
        ],
      ),
    );
  }
}
