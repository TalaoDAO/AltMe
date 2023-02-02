import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arago_identity_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AragoIdentityCardModel extends CredentialSubjectModel {
  AragoIdentityCardModel({
    this.familyName,
    this.givenName,
    this.bithPlace,
    this.birthDate,
    this.addressCountry,
    super.issuedBy,
    super.id,
    super.type,
  }) : super(
          credentialSubjectType: CredentialSubjectType.aragoIdentityCard,
          credentialCategory: CredentialCategory.passCards,
        );

  factory AragoIdentityCardModel.fromJson(Map<String, dynamic> json) =>
      _$AragoIdentityCardModelFromJson(json);

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
  Map<String, dynamic> toJson() => _$AragoIdentityCardModelToJson(this);
}
