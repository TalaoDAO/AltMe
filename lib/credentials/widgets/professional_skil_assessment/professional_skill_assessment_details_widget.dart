import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ProfessionalSkillAssessmentDetailsWidget extends StatelessWidget {
  const ProfessionalSkillAssessmentDetailsWidget(
      {Key? key, required this.model})
      : super(key: key);
  final ProfessionalExperienceAssessmentModel model;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Column(
      children: [
        CredentialField(title: localizations.lastName, value: model.givenName),
        CredentialField(
            title: localizations.firstName, value: model.familyName),
        SkillsListDisplay(
          skillWidgetList: model.skills,
        ),
        Column(
          children: model.signatureLines
              .map((e) =>
                  DisplaySignatures(localizations: localizations, item: e))
              .toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DisplayIssuer(
            issuer: model.issuedBy,
          ),
        ),
      ],
    );
  }
}
