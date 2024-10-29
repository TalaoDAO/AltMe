// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liveness_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivenessCardModel _$LivenessCardModelFromJson(Map<String, dynamic> json) =>
    LivenessCardModel(
      expires: json['expires'] as String? ?? '',
      offers: json['offers'] == null
          ? null
          : Offers.fromJson(json['offers'] as Map<String, dynamic>),
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$LivenessCardModelToJson(LivenessCardModel instance) {
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
  val['offers'] = instance.offers?.toJson();
  return val;
}
