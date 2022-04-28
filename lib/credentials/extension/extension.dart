import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

extension CredentialTypeExtension on CredentialType {
  Color backgroundColor() {
    switch (this) {
      case CredentialType.residentCard:
        return Colors.white;
      case CredentialType.selfIssued:
        return const Color(0xffEFF0F6);
      case CredentialType.identityPass:
        return const Color(0xffCAFFBF);
      case CredentialType.voucher:
        return const Color(0xffCAFFBF);
      case CredentialType.loyaltyCard:
        return const Color(0xffCAFFBF);
      case CredentialType.over18:
        return const Color(0xffCAFFBF);
      case CredentialType.professionalStudentCard:
        return const Color(0xffCAFFBF);
      case CredentialType.certificateOfEmployment:
        return const Color(0xFF9BF6FF);
      case CredentialType.emailPass:
        return const Color(0xFFffD6A5);
      case CredentialType.phonePass:
        return const Color(0xFFffD6A5);
      case CredentialType.professionalExperienceAssessment:
        return const Color(0xFFFFADAD);
      case CredentialType.professionalSkillAssessment:
        return const Color(0xffCAFFBF);
      case CredentialType.learningAchievement:
        return const Color(0xFFFFADAD);
      case CredentialType.ecole42LearningAchievement:
        return const Color(0xFFffD6A5);
      case CredentialType.defaultCredential:
        return Colors.black;
    }
  }

  Icon icon() {
    switch (this) {
      case CredentialType.residentCard:
        return const Icon(Icons.home);
      case CredentialType.selfIssued:
        return const Icon(Icons.perm_identity);
      case CredentialType.identityPass:
        return const Icon(Icons.perm_identity);
      case CredentialType.voucher:
        return const Icon(Icons.gamepad);
      case CredentialType.loyaltyCard:
        return const Icon(Icons.loyalty);
      case CredentialType.over18:
        return const Icon(Icons.accessible_rounded);
      case CredentialType.professionalStudentCard:
        return const Icon(Icons.perm_identity);
      case CredentialType.certificateOfEmployment:
        return const Icon(Icons.work);
      case CredentialType.emailPass:
        return const Icon(Icons.mail);
      case CredentialType.phonePass:
        return const Icon(Icons.phone);
      case CredentialType.professionalExperienceAssessment:
        return const Icon(Icons.add_road_outlined);
      case CredentialType.professionalSkillAssessment:
        return const Icon(Icons.assessment_outlined);
      case CredentialType.learningAchievement:
        return const Icon(Icons.star_rate_outlined);
      case CredentialType.ecole42LearningAchievement:
        return const Icon(Icons.perm_identity);
      case CredentialType.defaultCredential:
        return const Icon(Icons.fact_check_outlined);
    }
  }
}
