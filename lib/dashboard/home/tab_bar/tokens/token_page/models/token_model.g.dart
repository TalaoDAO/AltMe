// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
      contractAddress: json['contractAddress'] as String? ?? '',
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      decimalsToShow: (json['decimalsToShow'] as num?)?.toInt() ?? 2,
      icon: json['icon'] as String?,
      thumbnailUri: json['thumbnailUri'] as String?,
      balance: json['balance'] as String,
      decimals: json['decimals'] as String? ?? '0',
      tokenUSDPrice: (json['tokenUSDPrice'] as num?)?.toDouble() ?? 0,
      balanceInUSD: (json['balanceInUSD'] as num?)?.toDouble() ?? 0,
      standard: json['standard'] as String?,
      tokenId: json['tokenId'] as String? ?? '0',
    );

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'contractAddress': instance.contractAddress,
      'symbol': instance.symbol,
      'name': instance.name,
      'icon': instance.icon,
      'thumbnailUri': instance.thumbnailUri,
      'balance': instance.balance,
      'decimals': instance.decimals,
      'tokenUSDPrice': instance.tokenUSDPrice,
      'balanceInUSD': instance.balanceInUSD,
      'tokenId': instance.tokenId,
      'standard': instance.standard,
      'decimalsToShow': instance.decimalsToShow,
    };
