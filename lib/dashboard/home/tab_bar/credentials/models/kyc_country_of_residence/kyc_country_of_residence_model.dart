import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kyc_country_of_residence_model.g.dart';

@JsonSerializable(explicitToJson: true)
class KYCCountryOfResidenceModel extends CredentialSubjectModel {
  KYCCountryOfResidenceModel({
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
    this.countryCode,
    this.documentType,
  }) : super(
          credentialSubjectType: CredentialSubjectType.kycCountryOfResidence,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory KYCCountryOfResidenceModel.fromJson(Map<String, dynamic> json) =>
      _$KYCCountryOfResidenceModelFromJson(json);

  final int? countryCode;
  final int? documentType;

  @override
  Map<String, dynamic> toJson() => _$KYCCountryOfResidenceModelToJson(this);
}
