// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityPassModel _$IdentityPassModelFromJson(Map<String, dynamic> json) =>
    IdentityPassModel(
      recipient: json['recipient'] == null
          ? null
          : IdentityPassRecipient.fromJson(
              json['recipient'] as Map<String, dynamic>,
            ),
      expires: json['expires'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      id: json['id'] as String?,
      type: json['type'],
    );

Map<String, dynamic> _$IdentityPassModelToJson(IdentityPassModel instance) {
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
  val['recipient'] = instance.recipient?.toJson();
  val['expires'] = instance.expires;
  return val;
}
