import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verifiable_identity_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VerifiableIdCardModel extends CredentialSubjectModel {
  VerifiableIdCardModel({
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
          credentialSubjectType: CredentialSubjectType.verifiableIdCard,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory VerifiableIdCardModel.fromJson(Map<String, dynamic> json) =>
      _$VerifiableIdCardModelFromJson(json);

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
  Map<String, dynamic> toJson() => _$VerifiableIdCardModelToJson(this);
}
