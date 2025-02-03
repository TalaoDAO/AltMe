// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_fee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkFeeModel _$NetworkFeeModelFromJson(Map<String, dynamic> json) =>
    NetworkFeeModel(
      totalFee: json['totalFee'] as String,
      networkSpeed: $enumDecode(_$NetworkSpeedEnumMap, json['networkSpeed']),
      feeInUSD: (json['feeInUSD'] as num?)?.toDouble() ?? 0.0,
      tokenSymbol: json['tokenSymbol'] as String? ?? 'XTZ',
      bakerFee: json['bakerFee'] as String?,
    );

Map<String, dynamic> _$NetworkFeeModelToJson(NetworkFeeModel instance) =>
    <String, dynamic>{
      'totalFee': instance.totalFee,
      'bakerFee': instance.bakerFee,
      'feeInUSD': instance.feeInUSD,
      'tokenSymbol': instance.tokenSymbol,
      'networkSpeed': _$NetworkSpeedEnumMap[instance.networkSpeed]!,
    };

const _$NetworkSpeedEnumMap = {
  NetworkSpeed.slow: 'slow',
  NetworkSpeed.average: 'average',
  NetworkSpeed.fast: 'fast',
};
