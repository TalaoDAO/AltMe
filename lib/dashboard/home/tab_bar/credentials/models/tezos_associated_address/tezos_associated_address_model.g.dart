// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tezos_associated_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TezosAssociatedAddressModel _$TezosAssociatedAddressModelFromJson(
        Map<String, dynamic> json) =>
    TezosAssociatedAddressModel(
      associatedAddress: json['associatedAddress'] as String? ?? '',
      id: json['id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$TezosAssociatedAddressModelToJson(
        TezosAssociatedAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'associatedAddress': instance.associatedAddress,
    };
