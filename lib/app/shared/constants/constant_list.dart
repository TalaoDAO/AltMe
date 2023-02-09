import 'package:altme/app/app.dart';

class DiscoverList {
  static final List<CredentialSubjectType> gamingCategories = [
    // CredentialSubjectType.tezotopiaMembership,
    // CredentialSubjectType.chainbornMembership,
    // CredentialSubjectType.troopezPass,
    // CredentialSubjectType.pigsPass,
    // CredentialSubjectType.matterlightPass,
    // // CredentialSubjectType.dogamiPass,
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
    CredentialSubjectType.verifiableIdCard,
    CredentialSubjectType.phonePass,
    CredentialSubjectType.twitterCard,
  ];
  static final List<CredentialSubjectType> myProfessionalCategories = [
    // CredentialSubjectType.linkedInCard,
  ];
}
