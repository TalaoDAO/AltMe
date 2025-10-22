// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tezos_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TezosNetwork _$TezosNetworkFromJson(Map<String, dynamic> json) => TezosNetwork(
      networkname: json['networkname'] as String,
      apiUrl: json['apiUrl'] as String,
      rpcNodeUrl: json['rpcNodeUrl'],
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      type: $enumDecode(_$BlockchainTypeEnumMap, json['type']),
      isMainNet: json['isMainNet'] as bool,
      apiKey: json['apiKey'] as String? ?? '',
    );

Map<String, dynamic> _$TezosNetworkToJson(TezosNetwork instance) =>
    <String, dynamic>{
      'networkname': instance.networkname,
      'apiUrl': instance.apiUrl,
      'apiKey': instance.apiKey,
      'rpcNodeUrl': instance.rpcNodeUrl,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'type': _$BlockchainTypeEnumMap[instance.type]!,
      'isMainNet': instance.isMainNet,
    };

const _$BlockchainTypeEnumMap = {
  BlockchainType.tezos: 'tezos',
  BlockchainType.ethereum: 'ethereum',
  BlockchainType.fantom: 'fantom',
  BlockchainType.polygon: 'polygon',
  BlockchainType.binance: 'binance',
  BlockchainType.etherlink: 'etherlink',
};
