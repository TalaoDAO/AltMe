// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_range_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgeRangeModel _$AgeRangeModelFromJson(Map<String, dynamic> json) =>
    AgeRangeModel(
      expires: json['expires'] as String? ?? '',
      ageRange: json['ageRange'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$AgeRangeModelToJson(AgeRangeModel instance) {
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
  val['expires'] = instance.expires;
  val['ageRange'] = instance.ageRange;
  return val;
}
