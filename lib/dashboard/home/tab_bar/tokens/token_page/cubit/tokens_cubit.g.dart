// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensState _$TokensStateFromJson(Map<String, dynamic> json) => TokensState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TokenModel.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      isSecure: json['isSecure'] as bool? ?? false,
      totalBalanceInUSD: (json['totalBalanceInUSD'] as num?)?.toDouble() ?? 0.0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      blockchainType: $enumDecodeNullable(
              _$BlockchainTypeEnumMap, json['blockchainType']) ??
          BlockchainType.tezos,
    );

Map<String, dynamic> _$TokensStateToJson(TokensState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'data': instance.data.toList(),
      'isSecure': instance.isSecure,
      'totalBalanceInUSD': instance.totalBalanceInUSD,
      'offset': instance.offset,
      'blockchainType': _$BlockchainTypeEnumMap[instance.blockchainType]!,
    };

const _$AppStatusEnumMap = {
  AppStatus.init: 'init',
  AppStatus.fetching: 'fetching',
  AppStatus.loading: 'loading',
  AppStatus.populate: 'populate',
  AppStatus.error: 'error',
  AppStatus.errorWhileFetching: 'errorWhileFetching',
  AppStatus.success: 'success',
  AppStatus.idle: 'idle',
  AppStatus.goBack: 'goBack',
  AppStatus.revoked: 'revoked',
  AppStatus.addEnterpriseAccount: 'addEnterpriseAccount',
  AppStatus.updateEnterpriseAccount: 'updateEnterpriseAccount',
  AppStatus.replaceEnterpriseAccount: 'replaceEnterpriseAccount',
  AppStatus.restoreWallet: 'restoreWallet',
  AppStatus.successAdd: 'successAdd',
  AppStatus.successUpdate: 'successUpdate',
};

const _$BlockchainTypeEnumMap = {
  BlockchainType.tezos: 'tezos',
  BlockchainType.ethereum: 'ethereum',
  BlockchainType.fantom: 'fantom',
  BlockchainType.polygon: 'polygon',
  BlockchainType.binance: 'binance',
  BlockchainType.etherlink: 'etherlink',
};
