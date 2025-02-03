// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ethereum_nft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EthereumNftModel _$EthereumNftModelFromJson(Map<String, dynamic> json) =>
    EthereumNftModel(
      name: json['name'] as String? ?? '',
      tokenId: json['tokenId'] as String? ?? '0',
      contractAddress: json['contractAddress'] as String,
      balance: json['balance'] as String,
      symbol: json['symbol'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String,
      minterAddress: json['minter_address'] as String?,
      lastMetadataSync: json['last_metadata_sync'] as String?,
    );

Map<String, dynamic> _$EthereumNftModelToJson(EthereumNftModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'symbol': instance.symbol,
      'tokenId': instance.tokenId,
      'description': instance.description,
      'contractAddress': instance.contractAddress,
      'balance': instance.balance,
      'type': instance.type,
      'minter_address': instance.minterAddress,
      'last_metadata_sync': instance.lastMetadataSync,
    };
