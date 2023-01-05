import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'linkedin_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LinkedinCardModel extends CredentialSubjectModel {
  LinkedinCardModel({
    this.familyName,
    this.givenName,
    this.bithPlace,
    this.birthDate,
    this.addressCountry,
    Author? issuedBy,
    String? id,
    String? type,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.linkedInCard,
          credentialCategory: CredentialCategory.myProfessionalCards,
        );

  factory LinkedinCardModel.fromJson(Map<String, dynamic> json) =>
      _$LinkedinCardModelFromJson(json);

  @JsonKey(defaultValue: '')
  String? familyName;
  @JsonKey(defaultValue: '')
  String? givenName;
  @JsonKey(defaultValue: '')
  String? birthDate;
  @JsonKey(defaultValue: '')
  String? bithPlace;
  @JsonKey(defaultValue: '')
  String? addressCountry;

  @override
  Map<String, dynamic> toJson() => _$LinkedinCardModelToJson(this);
}
