import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialSubjectModel {
  CredentialSubjectModel({
    this.id,
    this.type,
    this.issuedBy,
    required this.credentialSubjectType,
  });

  factory CredentialSubjectModel.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'ResidentCard':
        return ResidentCardModel.fromJson(json);
      case 'SelfIssued':
        return SelfIssuedModel.fromJson(json);
      case 'IdentityPass':
        return IdentityPassModel.fromJson(json);
      case 'Voucher':
        return VoucherModel.fromJson(json);
      case 'Ecole42LearningAchievement':
        return Ecole42LearningAchievementModel.fromJson(json);
      case 'LoyaltyCard':
        return LoyaltyCardModel.fromJson(json);
      case 'Over18':
        return Over18Model.fromJson(json);
      case 'ProfessionalStudentCard':
        return ProfessionalStudentCardModel.fromJson(json);
      case 'StudentCard':
        return StudentCardModel.fromJson(json);
      case 'CertificateOfEmployment':
        return CertificateOfEmploymentModel.fromJson(json);
      case 'EmailPass':
        return EmailPassModel.fromJson(json);
      case 'PhonePass':
        return PhonePassModel.fromJson(json);
      case 'ProfessionalExperienceAssessment':
        return ProfessionalExperienceAssessmentModel.fromJson(json);
      case 'ProfessionalSkillAssessment':
        return ProfessionalSkillAssessmentModel.fromJson(json);
      case 'LearningAchievement':
        return LearningAchievementModel.fromJson(json);
    }
    return DefaultCredentialSubjectModel.fromJson(json);
  }

  final String? id;
  final String? type;
  @JsonKey(fromJson: fromJsonAuthor)
  final Author? issuedBy;
  final CredentialSubjectType credentialSubjectType;

  Color get backgroundColor {
    Color _backgroundColor;
    switch (type) {
      case 'ResidentCard':
        _backgroundColor = Colors.white;
        break;
      case 'SelfIssued':
        _backgroundColor = const Color(0xffEFF0F6);
        break;
      case 'IdentityPass':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'Voucher':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'LoyaltyCard':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'Over18':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'ProfessionalStudentCard':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'CertificateOfEmployment':
        _backgroundColor = const Color(0xFF9BF6FF);
        break;
      case 'EmailPass':
        _backgroundColor = const Color(0xFFffD6A5);
        break;
      case 'PhonePass':
        _backgroundColor = const Color(0xFFffD6A5);
        break;
      case 'ProfessionalExperienceAssessment':
        _backgroundColor = const Color(0xFFFFADAD);
        break;
      case 'ProfessionalSkillAssessment':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'LearningAchievement':
        _backgroundColor = const Color(0xFFFFADAD);
        break;
      default:
        _backgroundColor = Colors.black;
    }
    return _backgroundColor;
  }

  Icon get icon {
    Icon _icon;
    switch (type) {
      case 'ResidentCard':
        _icon = const Icon(Icons.home);
        break;
      case 'IdentityPass':
        _icon = const Icon(Icons.perm_identity);
        break;
      case 'Voucher':
        _icon = const Icon(Icons.gamepad);
        break;
      case 'LoyaltyCard':
        _icon = const Icon(Icons.loyalty);
        break;
      case 'Over18':
        _icon = const Icon(Icons.accessible_rounded);
        break;
      case 'ProfessionalStudentCard':
        _icon = const Icon(Icons.perm_identity);
        break;
      case 'CertificateOfEmployment':
        _icon = const Icon(Icons.work);
        break;
      case 'EmailPass':
        _icon = const Icon(Icons.mail);
        break;
      case 'PhonePass':
        _icon = const Icon(Icons.phone);
        break;
      case 'ProfessionalExperienceAssessment':
        _icon = const Icon(Icons.add_road_outlined);
        break;
      case 'ProfessionalSkillAssessment':
        _icon = const Icon(Icons.assessment_outlined);
        break;
      case 'LearningAchievement':
        _icon = const Icon(Icons.star_rate_outlined);
        break;
      default:
        _icon = const Icon(Icons.fact_check_outlined);
    }
    return _icon;
  }

  Map<String, dynamic> toJson() => _$CredentialSubjectModelToJson(this);

  static Author fromJsonAuthor(dynamic json) {
    if (json == null || json == '') {
      return const Author('', '');
    }
    return Author.fromJson(json as Map<String, dynamic>);
  }
}
