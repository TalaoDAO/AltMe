// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ethereum_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EthereumNetwork _$EthereumNetworkFromJson(Map<String, dynamic> json) =>
    EthereumNetwork(
      networkname: json['networkname'] as String,
      apiUrl: json['apiUrl'] as String,
      rpcNodeUrl: json['rpcNodeUrl'],
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      chainId: (json['chainId'] as num).toInt(),
      chain: json['chain'] as String,
      mainTokenName: json['mainTokenName'] as String? ?? 'Ethereum',
      mainTokenDecimal: json['mainTokenDecimal'] as String? ?? '18',
      mainTokenIcon: json['mainTokenIcon'] as String? ?? IconStrings.ethereum,
      mainTokenSymbol: json['mainTokenSymbol'] as String? ?? 'ETH',
      type: $enumDecode(_$BlockchainTypeEnumMap, json['type']),
      apiKey: json['apiKey'] as String? ?? '',
      isMainNet: json['isMainNet'] as bool,
    );

Map<String, dynamic> _$EthereumNetworkToJson(EthereumNetwork instance) =>
    <String, dynamic>{
      'networkname': instance.networkname,
      'apiUrl': instance.apiUrl,
      'apiKey': instance.apiKey,
      'rpcNodeUrl': instance.rpcNodeUrl,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'type': _$BlockchainTypeEnumMap[instance.type]!,
      'isMainNet': instance.isMainNet,
      'chainId': instance.chainId,
      'chain': instance.chain,
      'mainTokenName': instance.mainTokenName,
      'mainTokenSymbol': instance.mainTokenSymbol,
      'mainTokenIcon': instance.mainTokenIcon,
      'mainTokenDecimal': instance.mainTokenDecimal,
    };

const _$BlockchainTypeEnumMap = {
  BlockchainType.tezos: 'tezos',
  BlockchainType.ethereum: 'ethereum',
  BlockchainType.fantom: 'fantom',
  BlockchainType.polygon: 'polygon',
  BlockchainType.binance: 'binance',
  BlockchainType.etherlink: 'etherlink',
};
