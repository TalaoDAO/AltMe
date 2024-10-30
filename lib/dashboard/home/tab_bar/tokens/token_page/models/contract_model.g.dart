// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractModel _$ContractModelFromJson(Map<String, dynamic> json) =>
    ContractModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      image: json['image'] as String?,
      name: json['name'] as String?,
      currentPrice: (json['currentPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ContractModelToJson(ContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image': instance.image,
      'currentPrice': instance.currentPrice,
    };
