// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tezotopia_voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TezotopiaVoucherModel _$TezotopiaVoucherModelFromJson(
        Map<String, dynamic> json) =>
    TezotopiaVoucherModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      identifier: json['identifier'] as String? ?? '',
      offers: json['offers'] == null
          ? null
          : Offers.fromJson(json['offers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TezotopiaVoucherModelToJson(
        TezotopiaVoucherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'offers': instance.offers?.toJson(),
      'identifier': instance.identifier,
    };
