import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ProfessionalSkillAssessmentWidget extends StatelessWidget {
  const ProfessionalSkillAssessmentWidget({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final professionalSkillAssessmentModel = credentialModel.credentialPreview
        .credentialSubjectModel as ProfessionalSkillAssessmentModel;

    return CredentialBackground(
      credentialModel: credentialModel,
      child: Column(
        children: [
          CredentialField(
            title: l10n.lastName,
            value: professionalSkillAssessmentModel.givenName!,
          ),
          CredentialField(
            title: l10n.firstName,
            value: professionalSkillAssessmentModel.familyName!,
          ),
          SkillsListDisplay(
            skillWidgetList: professionalSkillAssessmentModel.skills!,
          ),
          Column(
            children: professionalSkillAssessmentModel.signatureLines!
                .map(
                  (e) => DisplaySignatures(
                    localizations: l10n,
                    signature: e,
                  ),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 40,
              child: DisplayIssuer(
                issuer: professionalSkillAssessmentModel.issuedBy!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
