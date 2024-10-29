// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over65_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over65Model _$Over65ModelFromJson(Map<String, dynamic> json) => Over65Model(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$Over65ModelToJson(Over65Model instance) {
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
