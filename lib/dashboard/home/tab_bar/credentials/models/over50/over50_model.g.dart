// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over50_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over50Model _$Over50ModelFromJson(Map<String, dynamic> json) => Over50Model(
  id: json['id'] as String?,
  type: json['type'],
  issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
  offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
);

Map<String, dynamic> _$Over50ModelToJson(Over50Model instance) {
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
