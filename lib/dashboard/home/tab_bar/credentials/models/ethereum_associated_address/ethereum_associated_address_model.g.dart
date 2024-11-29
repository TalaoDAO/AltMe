// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ethereum_associated_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EthereumAssociatedAddressModel _$EthereumAssociatedAddressModelFromJson(
        Map<String, dynamic> json) =>
    EthereumAssociatedAddressModel(
      associatedAddress: json['associatedAddress'] as String? ?? '',
      id: json['id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$EthereumAssociatedAddressModelToJson(
        EthereumAssociatedAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'associatedAddress': instance.associatedAddress,
    };
