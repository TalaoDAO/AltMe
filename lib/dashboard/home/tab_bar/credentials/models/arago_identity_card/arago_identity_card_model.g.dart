// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arago_identity_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AragoIdentityCardModel _$AragoIdentityCardModelFromJson(
        Map<String, dynamic> json) =>
    AragoIdentityCardModel(
      familyName: json['familyName'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
      bithPlace: json['bithPlace'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      addressCountry: json['addressCountry'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      id: json['id'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$AragoIdentityCardModelToJson(
    AragoIdentityCardModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'issuedBy': instance.issuedBy?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('offeredBy', instance.offeredBy?.toJson());
  val['familyName'] = instance.familyName;
  val['givenName'] = instance.givenName;
  val['birthDate'] = instance.birthDate;
  val['bithPlace'] = instance.bithPlace;
  val['addressCountry'] = instance.addressCountry;
  return val;
}
