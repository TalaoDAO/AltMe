// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diploma_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiplomaCardModel _$DiplomaCardModelFromJson(Map<String, dynamic> json) =>
    DiplomaCardModel(
      familyName: json['familyName'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
      programName: json['programName'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      identifier: json['identifier'] as String? ?? '',
    );

Map<String, dynamic> _$DiplomaCardModelToJson(DiplomaCardModel instance) {
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
  val['identifier'] = instance.identifier;
  val['familyName'] = instance.familyName;
  val['givenName'] = instance.givenName;
  val['programName'] = instance.programName;
  return val;
}
