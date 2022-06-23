import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:json_annotation/json_annotation.dart';

part 'identity_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class IdentityCardModel extends CredentialSubjectModel {
  IdentityCardModel({
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
          credentialSubjectType: CredentialSubjectType.identityCard,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory IdentityCardModel.fromJson(Map<String, dynamic> json) =>
      _$IdentityCardModelFromJson(json);

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
  Map<String, dynamic> toJson() => _$IdentityCardModelToJson(this);
}
