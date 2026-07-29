// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xtz_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XtzData _$XtzDataFromJson(Map<String, dynamic> json) => XtzData(
  price: (json['price'] as num?)?.toDouble(),
  price24H: (json['price24H'] as num?)?.toDouble(),
  marketCap: (json['marketCap'] as num?)?.toDouble(),
  market24H: (json['market24H'] as num?)?.toDouble(),
  volume: (json['volume'] as num?)?.toDouble(),
  volume24H: (json['volume24H'] as num?)?.toDouble(),
  updated: json['updated'] == null
      ? null
      : DateTime.parse(json['updated'] as String),
);

Map<String, dynamic> _$XtzDataToJson(XtzData instance) => <String, dynamic>{
  'price': instance.price,
  'price24H': instance.price24H,
  'marketCap': instance.marketCap,
  'market24H': instance.market24H,
  'volume': instance.volume,
  'volume24H': instance.volume24H,
  'updated': instance.updated?.toIso8601String(),
};
