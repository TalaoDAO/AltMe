// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arago_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AragoPassModel _$AragoPassModelFromJson(Map<String, dynamic> json) =>
    AragoPassModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      identifier: json['identifier'] as String? ?? '',
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$AragoPassModelToJson(AragoPassModel instance) {
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
  return val;
}
