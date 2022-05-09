// ignore_for_file: overridden_fields

import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/credentials/models/credential_subject/credential_subject.dart';
import 'package:altme/credentials/models/professional_experience_assessment/skill.dart';
import 'package:altme/credentials/models/signature/signature.dart';
import 'package:altme/credentials/widgets/credential_background.dart';
import 'package:altme/credentials/widgets/display_issuer.dart';
import 'package:altme/credentials/widgets/display_signature.dart';
import 'package:altme/credentials/widgets/skills_list_display.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'professional_skill_assessment.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalSkillAssessment extends CredentialSubject {
  ProfessionalSkillAssessment(
    this.id,
    this.type,
    this.skills,
    this.issuedBy,
    this.signatureLines,
    this.familyName,
    this.givenName,
  ) : super(id, type, issuedBy);

  factory ProfessionalSkillAssessment.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalSkillAssessmentFromJson(json);

  @override
  final String id;
  @override
  final String type;
  final List<Skill> skills;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final List<Signature> signatureLines;

  @override
  Map<String, dynamic> toJson() => _$ProfessionalSkillAssessmentToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;
    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          CredentialField(title: l10n.lastName, value: givenName),
          CredentialField(title: l10n.firstName, value: familyName),
          SkillsListDisplay(
            skillWidgetList: skills,
          ),
          Column(
            children: signatureLines
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
