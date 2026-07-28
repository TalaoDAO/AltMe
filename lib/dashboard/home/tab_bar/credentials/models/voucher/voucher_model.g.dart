// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherModel _$VoucherModelFromJson(Map<String, dynamic> json) => VoucherModel(
  id: json['id'] as String?,
  type: json['type'],
  issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
  offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
  identifier: json['identifier'] as String? ?? '',
  offer: json['offer'] == null
      ? null
      : Offer.fromJson(json['offer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VoucherModelToJson(VoucherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'offeredBy': ?instance.offeredBy?.toJson(),
      'identifier': instance.identifier,
      'offer': instance.offer?.toJson(),
    };
