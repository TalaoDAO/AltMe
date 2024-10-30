// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verifiable_identity_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifiableIdCardModel _$VerifiableIdCardModelFromJson(
        Map<String, dynamic> json) =>
    VerifiableIdCardModel(
      familyName: json['familyName'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      bithPlace: json['bithPlace'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      addressCountry: json['addressCountry'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      id: json['id'] as String?,
      type: json['type'],
    );

Map<String, dynamic> _$VerifiableIdCardModelToJson(
    VerifiableIdCardModel instance) {
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
  val['firstName'] = instance.firstName;
  val['birthDate'] = instance.birthDate;
  val['dateOfBirth'] = instance.dateOfBirth;
  val['bithPlace'] = instance.bithPlace;
  val['addressCountry'] = instance.addressCountry;
  return val;
}
