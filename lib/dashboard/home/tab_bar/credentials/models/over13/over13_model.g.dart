// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over13_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over13Model _$Over13ModelFromJson(Map<String, dynamic> json) => Over13Model(
  id: json['id'] as String?,
  type: json['type'],
  issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
  offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
);

Map<String, dynamic> _$Over13ModelToJson(Over13Model instance) {
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
  return val;
}
