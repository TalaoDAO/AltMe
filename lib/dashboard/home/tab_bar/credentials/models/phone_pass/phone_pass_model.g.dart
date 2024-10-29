// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhonePassModel _$PhonePassModelFromJson(Map<String, dynamic> json) =>
    PhonePassModel(
      expires: json['expires'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$PhonePassModelToJson(PhonePassModel instance) {
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
  val['phone'] = instance.phone;
  return val;
}
