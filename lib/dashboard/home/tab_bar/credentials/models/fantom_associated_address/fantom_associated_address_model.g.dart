// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fantom_associated_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FantomAssociatedAddressModel _$FantomAssociatedAddressModelFromJson(
        Map<String, dynamic> json) =>
    FantomAssociatedAddressModel(
      associatedAddress: json['associatedAddress'] as String? ?? '',
      id: json['id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$FantomAssociatedAddressModelToJson(
        FantomAssociatedAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'associatedAddress': instance.associatedAddress,
    };
