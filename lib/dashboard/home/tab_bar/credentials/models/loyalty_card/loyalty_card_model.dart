import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loyalty_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoyaltyCardModel extends CredentialSubjectModel {
  LoyaltyCardModel({
    super.id,
    super.type,
    this.address,
    this.familyName,
    super.issuedBy,
    this.birthDate,
    this.givenName,
    this.programName,
    this.telephone,
    this.email,
  }) : super(
          credentialSubjectType: CredentialSubjectType.loyaltyCard,
          credentialCategory: CredentialCategory.communityCards,
        );

  factory LoyaltyCardModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyCardModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? address;
  @JsonKey(defaultValue: '')
  final String? familyName;
  @JsonKey(defaultValue: '')
  final String? birthDate;
  @JsonKey(defaultValue: '')
  final String? givenName;
  @JsonKey(defaultValue: '')
  final String? programName;
  @JsonKey(defaultValue: '')
  final String? telephone;
  @JsonKey(defaultValue: '')
  final String? email;

  @override
  Map<String, dynamic> toJson() => _$LoyaltyCardModelToJson(this);
}
