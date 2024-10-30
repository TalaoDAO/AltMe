// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tezos_nft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TezosNftModel _$TezosNftModelFromJson(Map<String, dynamic> json) =>
    TezosNftModel(
      name: json['name'] as String? ?? '',
      displayUri: json['displayUri'] as String?,
      thumbnailUri: json['thumbnailUri'] as String?,
      description: json['description'] as String?,
      tokenId: json['tokenId'] as String? ?? '0',
      contractAddress: json['contractAddress'] as String,
      balance: json['balance'] as String,
      isTransferable: json['isTransferable'] as bool? ?? true,
      id: (json['id'] as num).toInt(),
      symbol: json['symbol'] as String?,
      standard: json['standard'] as String?,
      identifier: json['identifier'] as String?,
      mCreators: json['creators'],
      mPublishers: json['publishers'],
      date: json['date'] as String?,
      firstTime: json['firstTime'] as String?,
      artifactUri: json['artifactUri'] as String? ?? '',
    );

Map<String, dynamic> _$TezosNftModelToJson(TezosNftModel instance) =>
    <String, dynamic>{
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
      'standard': instance.standard,
      'id': instance.id,
      'identifier': instance.identifier,
      'creators': instance.mCreators,
      'publishers': instance.mPublishers,
      'date': instance.date,
      'firstTime': instance.firstTime,
    };
