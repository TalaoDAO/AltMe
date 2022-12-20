import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:flutter/material.dart';

part 'credential_subject_type_extension.dart';

enum CredentialSubjectType {
  bloometaPass,
  tezoniaPass,
  tzlandPass,
  troopezPass,
  pigsPass,
  matterlightPass,
  dogamiPass,
  bunnyPass,
  tezotopiaMembership,
  chainbornMembership,
  ageRange,
  nationality,
  gender,
  deviceInfo,
  tezosAssociatedWallet,
  ethereumAssociatedWallet,
  certificateOfEmployment,
  defaultCredential,
  ecole42LearningAchievement,
  emailPass,
  identityPass,
  identityCard,
  learningAchievement,
  loyaltyCard,
  over18,
  over13,
  passportFootprint,
  phonePass,
  professionalExperienceAssessment,
  professionalSkillAssessment,
  professionalStudentCard,
  residentCard,
  selfIssued,
  studentCard,
  voucher,
  tezVoucher,
  talaoCommunityCard,
  diplomaCard,
  aragoPass,
  aragoEmailPass,
  aragoIdentityCard,
  aragoLearningAchievement,
  aragoOver18,
  pcdsAgentCertificate,
}

extension CredentialSubjectTypeX on CredentialSubjectType {
  bool isDisabled() {
    if (this == CredentialSubjectType.dogamiPass) {
      return true;
    } else if (this == CredentialSubjectType.pigsPass) {
      return true;
    } else if (this == CredentialSubjectType.bunnyPass) {
      return true;
    } else if (this == CredentialSubjectType.troopezPass) {
      return true;
    } else if (this == CredentialSubjectType.tzlandPass) {
      return true;
    } else if (this == CredentialSubjectType.matterlightPass) {
      return true;
    } else if (this == CredentialSubjectType.tezoniaPass) {
      return true;
    } else {
      return false;
    }
  }
}
