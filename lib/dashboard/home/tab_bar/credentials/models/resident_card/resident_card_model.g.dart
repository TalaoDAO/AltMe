// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentCardModel _$ResidentCardModelFromJson(Map<String, dynamic> json) =>
    ResidentCardModel(
      id: json['id'] as String?,
      gender: json['gender'] as String? ?? '',
      maritalStatus: json['maritalStatus'] as String? ?? '',
      type: json['type'],
      birthPlace: json['birthPlace'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      address: json['address'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      familyName: json['familyName'] as String? ?? '',
      image: json['image'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      birthDate: json['birthDate'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
    );

Map<String, dynamic> _$ResidentCardModelToJson(ResidentCardModel instance) {
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
  val['gender'] = instance.gender;
  val['maritalStatus'] = instance.maritalStatus;
  val['birthPlace'] = instance.birthPlace;
  val['nationality'] = instance.nationality;
  val['address'] = instance.address;
  val['identifier'] = instance.identifier;
  val['familyName'] = instance.familyName;
  val['image'] = instance.image;
  val['birthDate'] = instance.birthDate;
  val['givenName'] = instance.givenName;
  return val;
}
