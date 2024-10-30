// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tezotopia_membership_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TezotopiaMembershipModel _$TezotopiaMembershipModelFromJson(
        Map<String, dynamic> json) =>
    TezotopiaMembershipModel(
      expires: json['expires'] as String? ?? '',
      offers: json['offers'] == null
          ? null
          : Offers.fromJson(json['offers'] as Map<String, dynamic>),
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$TezotopiaMembershipModelToJson(
    TezotopiaMembershipModel instance) {
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
