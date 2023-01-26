import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ProfessionalExperienceAssessmentWidget extends StatelessWidget {
  const ProfessionalExperienceAssessmentWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final professionalExperienceAssessmentModel = credentialModel
        .credentialPreview
        .credentialSubjectModel as ProfessionalExperienceAssessmentModel;

    return CredentialBackground(
      credentialModel: credentialModel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CredentialField(
            title: l10n.lastName,
            value: professionalExperienceAssessmentModel.givenName!,
          ),
          CredentialField(
            title: l10n.firstName,
            value: professionalExperienceAssessmentModel.familyName!,
          ),
          CredentialField(
            title: l10n.jobTitle,
            value: professionalExperienceAssessmentModel.title!,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.from.toLowerCase()} ',
                  style: Theme.of(context).textTheme.credentialFieldTitle,
                ),
                Text(
                  UiDate.formatStringDate(
                    professionalExperienceAssessmentModel.startDate!,
                  ),
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
                Text(
                  ' ${l10n.to.toLowerCase()} ',
                  style: Theme.of(context).textTheme.credentialFieldTitle,
                ),
                Text(
                  UiDate.formatStringDate(
                    professionalExperienceAssessmentModel.endDate!,
                  ),
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
              ],
            ),
          ),
          CredentialField(
            value: professionalExperienceAssessmentModel.description!,
          ),
          SkillsListDisplay(
            skillWidgetList: professionalExperienceAssessmentModel.skills!,
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: professionalExperienceAssessmentModel.review!.length,
              itemBuilder: (context, index) {
                final item =
                    professionalExperienceAssessmentModel.review![index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GetTranslation.getTranslation(
                          item.reviewBody,
                          l10n,
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .professionalExperienceAssessmentRating,
                      ),
                      StarRating(
                        starCount: 5,
                        rating: double.parse(item.reviewRating.ratingValue),
                        color: Theme.of(context).colorScheme.star,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Column(
            children: professionalExperienceAssessmentModel.signatureLines!
                .map(
                  (e) => DisplaySignatures(localizations: l10n, signature: e),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 40,
              child: DisplayIssuer(
                issuer: professionalExperienceAssessmentModel.issuedBy!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
