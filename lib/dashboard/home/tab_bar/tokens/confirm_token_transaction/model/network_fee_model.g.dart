// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_fee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkFeeModel _$NetworkFeeModelFromJson(Map<String, dynamic> json) =>
    NetworkFeeModel(
      fee: (json['fee'] as num).toDouble(),
      feeInUSD: (json['feeInUSD'] as num?)?.toDouble() ?? 0.0,
      tokenSymbol: json['tokenSymbol'] as String? ?? 'XTZ',
      networkSpeed: $enumDecode(_$NetworkSpeedEnumMap, json['networkSpeed']),
    );

Map<String, dynamic> _$NetworkFeeModelToJson(NetworkFeeModel instance) =>
    <String, dynamic>{
      'fee': instance.fee,
      'feeInUSD': instance.feeInUSD,
      'tokenSymbol': instance.tokenSymbol,
      'networkSpeed': _$NetworkSpeedEnumMap[instance.networkSpeed]!,
    };

const _$NetworkSpeedEnumMap = {
  NetworkSpeed.slow: 'slow',
  NetworkSpeed.average: 'average',
  NetworkSpeed.fast: 'fast',
};
