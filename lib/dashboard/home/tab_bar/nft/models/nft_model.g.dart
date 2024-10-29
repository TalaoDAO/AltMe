// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftModel _$NftModelFromJson(Map<String, dynamic> json) => NftModel(
      tokenId: json['tokenId'] as String? ?? '0',
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String?,
      contractAddress: json['contractAddress'] as String,
      balance: json['balance'] as String,
      description: json['description'] as String?,
      displayUri: json['displayUri'] as String?,
      thumbnailUri: json['thumbnailUri'] as String?,
      isTransferable: json['isTransferable'] as bool? ?? true,
      artifactUri: json['artifactUri'] as String? ?? '',
    );

Map<String, dynamic> _$NftModelToJson(NftModel instance) => <String, dynamic>{
      'name': instance.name,
      'symbol': instance.symbol,
      'tokenId': instance.tokenId,
      'description': instance.description,
      'displayUri': instance.displayUri,
      'thumbnailUri': instance.thumbnailUri,
      'contractAddress': instance.contractAddress,
      'balance': instance.balance,
      'isTransferable': instance.isTransferable,
      'artifactUri': instance.artifactUri,
    };
