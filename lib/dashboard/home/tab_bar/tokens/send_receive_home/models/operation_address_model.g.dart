// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationAddressModel _$OperationAddressModelFromJson(
        Map<String, dynamic> json) =>
    OperationAddressModel(
      address: json['address'] as String,
      alias: json['alias'] as String?,
    );

Map<String, dynamic> _$OperationAddressModelToJson(
        OperationAddressModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'alias': instance.alias,
    };
