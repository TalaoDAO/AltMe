// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_account_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoAccountData _$CryptoAccountDataFromJson(Map<String, dynamic> json) =>
    CryptoAccountData(
      name: json['name'] as String,
      secretKey: json['secretKey'] as String,
      walletAddress: json['walletAddress'] as String,
      isImported: json['isImported'] as bool? ?? false,
      blockchainType: $enumDecodeNullable(
              _$BlockchainTypeEnumMap, json['blockchainType']) ??
          BlockchainType.tezos,
    );

Map<String, dynamic> _$CryptoAccountDataToJson(CryptoAccountData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'secretKey': instance.secretKey,
      'walletAddress': instance.walletAddress,
      'isImported': instance.isImported,
      'blockchainType': _$BlockchainTypeEnumMap[instance.blockchainType]!,
    };

const _$BlockchainTypeEnumMap = {
  BlockchainType.tezos: 'tezos',
  BlockchainType.ethereum: 'ethereum',
  BlockchainType.fantom: 'fantom',
  BlockchainType.polygon: 'polygon',
  BlockchainType.binance: 'binance',
  BlockchainType.etherlink: 'etherlink',
};
