import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

extension CredentialSubjectTypeExtension on CredentialSubjectType {
  Color backgroundColor() {
    switch (this) {
      case CredentialSubjectType.residentCard:
        return Colors.white;
      case CredentialSubjectType.selfIssued:
        return const Color(0xffEFF0F6);
      case CredentialSubjectType.identityPass:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.voucher:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.loyaltyCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.over18:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.professionalStudentCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.certificateOfEmployment:
        return const Color(0xFF9BF6FF);
      case CredentialSubjectType.emailPass:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.phonePass:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.professionalExperienceAssessment:
        return const Color(0xFFFFADAD);
      case CredentialSubjectType.professionalSkillAssessment:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.learningAchievement:
        return const Color(0xFFFFADAD);
      case CredentialSubjectType.ecole42LearningAchievement:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.studentCard:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.defaultCredential:
        return Colors.black;
    }
  }

  Icon icon() {
    switch (this) {
      case CredentialSubjectType.residentCard:
        return const Icon(Icons.home);
      case CredentialSubjectType.selfIssued:
        return const Icon(Icons.perm_identity);
      case CredentialSubjectType.identityPass:
        return const Icon(Icons.perm_identity);
      case CredentialSubjectType.voucher:
        return const Icon(Icons.gamepad);
      case CredentialSubjectType.loyaltyCard:
        return const Icon(Icons.loyalty);
      case CredentialSubjectType.over18:
        return const Icon(Icons.accessible_rounded);
      case CredentialSubjectType.professionalStudentCard:
        return const Icon(Icons.perm_identity);
      case CredentialSubjectType.certificateOfEmployment:
        return const Icon(Icons.work);
      case CredentialSubjectType.emailPass:
        return const Icon(Icons.mail);
      case CredentialSubjectType.phonePass:
        return const Icon(Icons.phone);
      case CredentialSubjectType.professionalExperienceAssessment:
        return const Icon(Icons.add_road_outlined);
      case CredentialSubjectType.professionalSkillAssessment:
        return const Icon(Icons.assessment_outlined);
      case CredentialSubjectType.learningAchievement:
        return const Icon(Icons.star_rate_outlined);
      case CredentialSubjectType.ecole42LearningAchievement:
        return const Icon(Icons.perm_identity);
      case CredentialSubjectType.studentCard:
        return const Icon(Icons.perm_identity);
      case CredentialSubjectType.defaultCredential:
        return const Icon(Icons.fact_check_outlined);
    }
  }
}
