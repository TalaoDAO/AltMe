import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loyalty_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoyaltyCardModel extends CredentialSubjectModel {
  LoyaltyCardModel({
    String? id,
    String? type,
    this.address,
    this.familyName,
    Author? issuedBy,
    this.birthDate,
    this.givenName,
    this.programName,
    this.telephone,
    this.email,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
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
