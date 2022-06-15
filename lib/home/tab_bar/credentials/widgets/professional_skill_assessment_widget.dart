import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ProfessionalSkillAssessmentDisplayInList extends StatelessWidget {
  const ProfessionalSkillAssessmentDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInList(
      credentialModel: credentialModel,
      descriptionMaxLine: 5,
    );
  }
}

class ProfessionalSkillAssessmentDisplayInSelectionList
    extends StatelessWidget {
  const ProfessionalSkillAssessmentDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInSelectionList(
      credentialModel: credentialModel,
    );
  }
}

class ProfessionalSkillAssessmentDisplayDetail extends StatelessWidget {
  const ProfessionalSkillAssessmentDisplayDetail({
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
                    item: e,
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
