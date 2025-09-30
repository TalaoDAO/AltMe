// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binance_associated_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BinanceAssociatedAddressModel _$BinanceAssociatedAddressModelFromJson(
        Map<String, dynamic> json) =>
    BinanceAssociatedAddressModel(
      associatedAddress: json['associatedAddress'] as String? ?? '',
      id: json['id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$BinanceAssociatedAddressModelToJson(
        BinanceAssociatedAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'associatedAddress': instance.associatedAddress,
    };
