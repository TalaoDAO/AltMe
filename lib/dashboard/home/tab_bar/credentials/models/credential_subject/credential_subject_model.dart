import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialSubjectModel {
  CredentialSubjectModel({
    this.id,
    this.type,
    this.issuedBy,
    required this.credentialSubjectType,
    required this.credentialCategory,
  });

  factory CredentialSubjectModel.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'DeviceInfo':
        return DeviceInfoModel.fromJson(json);
      case 'BloometaPass':
        return BloometaPassModel.fromJson(json);
      case 'MembershipCard_1':
        return TezotopiaMembershipModel.fromJson(json);
      case 'Chainborn_MembershipCard':
        return ChainbornMembershipModel.fromJson(json);
      case 'DogamiPass':
        return DogamiPassModel.fromJson(json);
      case 'TroopezPass':
        return TroopezPassModel.fromJson(json);
      case 'TezoniaPass':
        return TezoniaPassModel.fromJson(json);
      case 'BunnyPass':
        return BunnyPassModel.fromJson(json);
      case 'PigsPass':
        return PigsPassModel.fromJson(json);
      case 'TzlandPass':
        return TzlandPassModel.fromJson(json);
      case 'MatterlightPass':
        return MatterlightPassModel.fromJson(json);
      case 'Nationality':
        return NationalityModel.fromJson(json);
      case 'ResidentCard':
        return ResidentCardModel.fromJson(json);
      case 'Gender':
        return GenderModel.fromJson(json);
      case 'TezosAssociatedAddress':
        return TezosAssociatedAddressModel.fromJson(json);
      case 'EthereumAssociatedAddress':
        return EthereumAssociatedAddressModel.fromJson(json);
      case 'FantomAssociatedAddress':
        return FantomAssociatedAddressModel.fromJson(json);
      case 'PolygonAssociatedAddress':
        return PolygonAssociatedAddressModel.fromJson(json);
      case 'BinanceAssociatedAddress':
        return BinanceAssociatedAddressModel.fromJson(json);
      case 'SelfIssued':
        return SelfIssuedModel.fromJson(json);
      case 'IdentityPass':
        return IdentityPassModel.fromJson(json);
      case 'IdCard':
        return IdentityCardModel.fromJson(json);
      case 'Voucher':
        return VoucherModel.fromJson(json);
      case 'TezVoucher_1':
        return TezotopiaVoucherModel.fromJson(json);
      case 'Ecole42LearningAchievement':
        return Ecole42LearningAchievementModel.fromJson(json);
      case 'LoyaltyCard':
        return LoyaltyCardModel.fromJson(json);
      case 'Over18':
        return Over18Model.fromJson(json);
      case 'Over13':
        return Over13Model.fromJson(json);
      case 'PassportNumber':
        return PassportFootprintModel.fromJson(json);
      case 'ProfessionalStudentCard':
        return ProfessionalStudentCardModel.fromJson(json);
      case 'StudentCard':
        return StudentCardModel.fromJson(json);
      case 'CertificateOfEmployment':
        return CertificateOfEmploymentModel.fromJson(json);
      case 'EmailPass':
        return EmailPassModel.fromJson(json);
      case 'AgeRange':
        return AgeRangeModel.fromJson(json);
      case 'PhoneProof':
        return PhonePassModel.fromJson(json);
      case 'ProfessionalExperienceAssessment':
        return ProfessionalExperienceAssessmentModel.fromJson(json);
      case 'ProfessionalSkillAssessment':
        return ProfessionalSkillAssessmentModel.fromJson(json);
      case 'LearningAchievement':
        return LearningAchievementModel.fromJson(json);
      case 'TalaoCommunity':
        return TalaoCommunityCardModel.fromJson(json);
      case 'VerifiableDiploma':
        return DiplomaCardModel.fromJson(json);
      case 'AragoOver18':
        return AragoOver18Model.fromJson(json);
      case 'AragoPass':
        return AragoPassModel.fromJson(json);
      case 'AragoIdCard':
        return AragoIdentityCardModel.fromJson(json);
      case 'AragoEmailPass':
        return AragoEmailPassModel.fromJson(json);
      case 'AragoLearningAchievement':
        return AragoLearningAchievementModel.fromJson(json);
      case 'PCDSAgentCertificate':
        return PcdsAgentCertificateModel.fromJson(json);
    }
    return DefaultCredentialSubjectModel.fromJson(json);
  }

  final String? id;
  final String? type;
  @JsonKey(fromJson: fromJsonAuthor)
  final Author? issuedBy;
  final CredentialSubjectType credentialSubjectType;
  final CredentialCategory credentialCategory;

  Map<String, dynamic> toJson() => _$CredentialSubjectModelToJson(this);

  static Author fromJsonAuthor(dynamic json) {
    if (json == null || json == '') {
      return const Author('');
    }
    return Author.fromJson(json as Map<String, dynamic>);
  }
}
