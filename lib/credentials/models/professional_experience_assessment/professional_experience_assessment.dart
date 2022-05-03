// ignore_for_file: overridden_fields

import 'package:altme/app/shared/date/date.dart';
import 'package:altme/app/shared/translation/translation.dart';
import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/credentials/models/professional_experience_assessment/review.dart';
import 'package:altme/credentials/models/professional_experience_assessment/skill.dart';
import 'package:altme/credentials/models/signature/signature.dart';
import 'package:altme/credentials/widgets/display_signature.dart';
import 'package:altme/credentials/widgets/skills_list_display.dart';
import 'package:altme/credentials/widgets/star_rating.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'professional_experience_assessment.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalExperienceAssessment extends CredentialSubject {
  // ignore: require_trailing_commas
  ProfessionalExperienceAssessment(
    this.expires,
    this.email,
    this.id,
    this.type,
    this.skills,
    this.title,
    this.endDate,
    this.startDate,
    this.issuedBy,
    this.review,
    this.signatureLines,
    this.familyName,
    this.givenName,
    this.description,
  ) : super(id, type, issuedBy);

  factory ProfessionalExperienceAssessment.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProfessionalExperienceAssessmentFromJson(json);

  @override
  final String id;
  final List<Skill> skills;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(defaultValue: '')
  final String endDate;
  @JsonKey(defaultValue: '')
  final String startDate;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String email;
  @override
  final String type;
  @JsonKey(defaultValue: <Review>[])
  final List<Review> review;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final List<Signature> signatureLines;

  @override
  Map<String, dynamic> toJson() =>
      _$ProfessionalExperienceAssessmentToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;
    final _startDate = UiDate.displayDate(l10n, startDate);
    final _endDate = UiDate.displayDate(l10n, endDate);
    return CredentialBackground(
      model: item,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CredentialField(title: l10n.lastName, value: givenName),
          CredentialField(title: l10n.firstName, value: familyName),
          CredentialField(title: l10n.jobTitle, value: title),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.from} ',
                  style: Theme.of(context).textTheme.credentialFieldTitle,
                ),
                Text(
                  UiDate.displayDate(l10n, _startDate),
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
                Text(
                  ' ${l10n.to} ',
                  style: Theme.of(context).textTheme.credentialFieldTitle,
                ),
                Text(
                  UiDate.displayDate(l10n, _endDate),
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
              ],
            ),
          ),
          CredentialField(value: description),
          SkillsListDisplay(
            skillWidgetList: skills,
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: review.length,
              itemBuilder: (context, index) {
                final item = review[index];
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
            children: signatureLines
                .map(
                  (e) => DisplaySignatures(localizations: l10n, item: e),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DisplayIssuer(
              issuer: issuedBy,
            ),
          ),
        ],
      ),
    );
  }

  static List<Signature> _signatureLinesFromJson(dynamic json) {
    if (json == null || json == '') {
      return [];
    }
    if (json is List) {
      return json
          .map((dynamic e) => Signature.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Signature.fromJson(json as Map<String, dynamic>)];
  }
}
