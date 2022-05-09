import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ProfessionalExperienceAssessmentDetailsWidget extends StatelessWidget {
  const ProfessionalExperienceAssessmentDetailsWidget(
      {Key? key, required this.model})
      : super(key: key);
  final ProfessionalExperienceAssessmentModel model;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final _startDate = UIDate.displayDate(model.startDate);
    final _endDate = UIDate.displayDate(model.endDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CredentialField(title: localizations.lastName, value: model.givenName),
        CredentialField(
            title: localizations.firstName, value: model.familyName,),
        CredentialField(title: localizations.jobTitle, value: model.title),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(
                '${localizations.from} ',
                style: Theme.of(context).textTheme.credentialFieldTitle,
              ),
              Text(
                UIDate.displayDate(_startDate),
                style: Theme.of(context).textTheme.credentialFieldDescription,
              ),
              Text(
                ' ${localizations.to} ',
                style: Theme.of(context).textTheme.credentialFieldTitle,
              ),
              Text(
                UIDate.displayDate(_endDate),
                style: Theme.of(context).textTheme.credentialFieldDescription,
              ),
            ],
          ),
        ),
        CredentialField(value: model.description),
        SkillsListDisplay(
          skillWidgetList: model.skills,
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
              itemCount: model.review.length,
              itemBuilder: (context, index) {
                final item = model.review[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslation(item.reviewBody),
                        style: Theme.of(context)
                            .textTheme
                            .professionalExperienceAssessmentRating,
                      ),
                      StarRating(
                        starCount: 5,
                        rating: double.parse(item.reviewRating.ratingValue),
                        onRatingChanged: (_) => null,
                        color: Theme.of(context).colorScheme.star,
                      ),
                    ],
                  ),
                );
              }),
        ),
        Column(
          children: model.signatureLines
              .map((e) =>
                  DisplaySignatures(localizations: localizations, item: e))
              .toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DisplayIssuer(
            issuer: model.issuedBy,
          ),
        ),
      ],
    );
  }
}
