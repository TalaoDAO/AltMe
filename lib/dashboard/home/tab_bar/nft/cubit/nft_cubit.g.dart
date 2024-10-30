// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftState _$NftStateFromJson(Map<String, dynamic> json) => NftState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => NftModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      blockchainType: $enumDecodeNullable(
              _$BlockchainTypeEnumMap, json['blockchainType']) ??
          BlockchainType.tezos,
    );

Map<String, dynamic> _$NftStateToJson(NftState instance) => <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'data': instance.data,
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
};

const _$BlockchainTypeEnumMap = {
  BlockchainType.tezos: 'tezos',
  BlockchainType.ethereum: 'ethereum',
  BlockchainType.fantom: 'fantom',
  BlockchainType.polygon: 'polygon',
  BlockchainType.binance: 'binance',
  BlockchainType.etherlink: 'etherlink',
};
