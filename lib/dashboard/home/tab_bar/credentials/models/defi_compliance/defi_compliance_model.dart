import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'defi_compliance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DefiComplianceModel extends CredentialSubjectModel {
  DefiComplianceModel({
    this.expires,
    this.ageCheck,
    this.amlComplianceCheck,
    this.sanctionListCheck,
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
         credentialSubjectType: CredentialSubjectType.defiCompliance,
         credentialCategory: CredentialCategory.financeCards,
       );

  factory DefiComplianceModel.fromJson(Map<String, dynamic> json) =>
      _$DefiComplianceModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  @JsonKey(defaultValue: '')
  final String? ageCheck;
  @JsonKey(defaultValue: '')
  final String? amlComplianceCheck;
  @JsonKey(defaultValue: '')
  final String? sanctionListCheck;

  @override
  Map<String, dynamic> toJson() => _$DefiComplianceModelToJson(this);
}
