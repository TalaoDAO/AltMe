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
    );

Map<String, dynamic> _$EtherlinkAssociatedAddressModelToJson(
        EtherlinkAssociatedAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'associatedAddress': instance.associatedAddress,
    };
