// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blockchain_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockchainNetwork _$BlockchainNetworkFromJson(Map<String, dynamic> json) =>
    BlockchainNetwork(
      networkname: json['networkname'] as String,
      apiUrl: json['apiUrl'] as String,
      rpcNodeUrl: json['rpcNodeUrl'],
      title: json['title'] as String?,
      subTitle: json['subTitle'] as String?,
      type: $enumDecode(_$BlockchainTypeEnumMap, json['type']),
      apiKey: json['apiKey'] as String? ?? '',
    );

Map<String, dynamic> _$BlockchainNetworkToJson(BlockchainNetwork instance) =>
    <String, dynamic>{
      'networkname': instance.networkname,
      'apiUrl': instance.apiUrl,
      'apiKey': instance.apiKey,
      'rpcNodeUrl': instance.rpcNodeUrl,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'type': _$BlockchainTypeEnumMap[instance.type]!,
    };

const _$BlockchainTypeEnumMap = {
  BlockchainType.tezos: 'tezos',
  BlockchainType.ethereum: 'ethereum',
  BlockchainType.fantom: 'fantom',
  BlockchainType.polygon: 'polygon',
  BlockchainType.binance: 'binance',
  BlockchainType.etherlink: 'etherlink',
};
