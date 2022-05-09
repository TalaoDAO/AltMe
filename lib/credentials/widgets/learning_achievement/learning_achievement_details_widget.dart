import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class LearningAchievementDetailsWidget extends StatelessWidget {
  const LearningAchievementDetailsWidget(
      {Key? key, required this.learningAchievementModel})
      : super(key: key);
  final LearningAchievementModel learningAchievementModel;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Column(
      children: [
        CredentialField(
          value: learningAchievementModel.familyName,
          title: localizations.firstName,
        ),
        CredentialField(
          title: localizations.lastName,
          value: learningAchievementModel.givenName,
        ),
        CredentialField(
          title: localizations.personalMail,
          value: learningAchievementModel.email,
        ),
        CredentialField(
          title: localizations.birthdate,
          value: UIDate.displayDate(learningAchievementModel.birthDate),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            learningAchievementModel.hasCredential.title,
            style: Theme.of(context).textTheme.learningAchievementTitle,
            maxLines: 5,
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            learningAchievementModel.hasCredential.description,
            style: Theme.of(context).textTheme.learningAchievementDescription,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DisplayIssuer(
            issuer: learningAchievementModel.issuedBy,
          ),
        )
      ],
    );
  }
}
