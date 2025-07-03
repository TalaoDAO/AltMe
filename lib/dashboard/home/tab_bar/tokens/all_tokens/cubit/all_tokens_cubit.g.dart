// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_tokens_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllTokensState _$AllTokensStateFromJson(Map<String, dynamic> json) =>
    AllTokensState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      contracts: (json['contracts'] as List<dynamic>?)
              ?.map((e) => ContractModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      filteredContracts: (json['filteredContracts'] as List<dynamic>?)
              ?.map((e) => ContractModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedContracts: (json['selectedContracts'] as List<dynamic>?)
              ?.map((e) => ContractModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AllTokensStateToJson(AllTokensState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'contracts': instance.contracts,
      'filteredContracts': instance.filteredContracts,
      'selectedContracts': instance.selectedContracts,
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
  AppStatus.addEuropeanProfile: 'addEuropeanProfile',
  AppStatus.addInjiProfile: 'addInjiProfile',
};
