import 'package:altme/app/shared/enum/type/credential_subject_type/credential_subject_type.dart';

class DiscoverList {
  static final List<CredentialSubjectType> gamingCategories = [
    CredentialSubjectType.tezVoucher,
    CredentialSubjectType.tezotopiaMembership,
    // CredentialSubjectType.tezoniaPass,
    // CredentialSubjectType.tzlandPass,
    // CredentialSubjectType.troopezPass,
    // CredentialSubjectType.pigsPass,
    // CredentialSubjectType.matterlightPass,
    // CredentialSubjectType.dogamiPass,
    // CredentialSubjectType.bunnyPass,
  ];
  static final List<CredentialSubjectType> communityCategories = [
    // CredentialSubjectType.talaoCommunityCard
  ];
  static final List<CredentialSubjectType> identityCategories = [
    CredentialSubjectType.emailPass,
    //CredentialSubjectType.gender,
    CredentialSubjectType.ageRange,
    CredentialSubjectType.nationality,
    CredentialSubjectType.over18,
    CredentialSubjectType.over13,
    CredentialSubjectType.passportFootprint,
    CredentialSubjectType.identityCard,
    CredentialSubjectType.phonePass,
  ];
}

final List<CredentialSubjectType> membershipRequiredList = [
  CredentialSubjectType.ageRange,
  CredentialSubjectType.nationality,
];
