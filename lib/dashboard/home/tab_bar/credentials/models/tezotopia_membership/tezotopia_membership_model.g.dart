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
        TezotopiaMembershipModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'expires': instance.expires,
      'offers': instance.offers?.toJson(),
    };
