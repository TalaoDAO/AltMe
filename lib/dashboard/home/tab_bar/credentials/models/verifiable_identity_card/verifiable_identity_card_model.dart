import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verifiable_identity_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VerifiableIdCardModel extends CredentialSubjectModel {
  VerifiableIdCardModel({
    this.familyName,
    this.firstName,
    this.bithPlace,
    this.birthDate,
    this.dateOfBirth,
    this.addressCountry,
    super.issuedBy,
    super.offeredBy,
    super.id,
    super.type,
  }) : super(
         credentialSubjectType: CredentialSubjectType.verifiableIdCard,
         credentialCategory: CredentialCategory.identityCards,
       );

  factory VerifiableIdCardModel.fromJson(Map<String, dynamic> json) =>
      _$VerifiableIdCardModelFromJson(json);

  @JsonKey(defaultValue: '')
  String? familyName;
  @JsonKey(defaultValue: '')
  String? firstName;
  @JsonKey(defaultValue: '')
  String? birthDate;
  @JsonKey(defaultValue: '')
  String? dateOfBirth;
  @JsonKey(defaultValue: '')
  String? bithPlace;
  @JsonKey(defaultValue: '')
  String? addressCountry;

  @override
  Map<String, dynamic> toJson() => _$VerifiableIdCardModelToJson(this);
}
