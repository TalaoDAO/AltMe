// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etherlink_associated_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtherlinkAssociatedAddressModel _$EtherlinkAssociatedAddressModelFromJson(
        Map<String, dynamic> json) =>
    EtherlinkAssociatedAddressModel(
      associatedAddress: json['associatedAddress'] as String? ?? '',
      id: json['id'] as String,
      type: json['type'] as String,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$EtherlinkAssociatedAddressModelToJson(
        EtherlinkAssociatedAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'associatedAddress': instance.associatedAddress,
    };
