// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailPassModel _$EmailPassModelFromJson(Map<String, dynamic> json) =>
    EmailPassModel(
      expires: json['expires'] as String? ?? '',
      email: json['email'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      passbaseMetadata: json['passbaseMetadata'] as String? ?? '',
    );

Map<String, dynamic> _$EmailPassModelToJson(EmailPassModel instance) {
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
  val['email'] = instance.email;
  val['passbaseMetadata'] = instance.passbaseMetadata;
  return val;
}
