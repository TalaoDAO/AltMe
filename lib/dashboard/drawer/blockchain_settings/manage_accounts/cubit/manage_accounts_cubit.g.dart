// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_accounts_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManageAccountsState _$ManageAccountsStateFromJson(Map<String, dynamic> json) =>
    ManageAccountsState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      currentCryptoIndex: (json['currentCryptoIndex'] as num?)?.toInt() ?? 0,
      cryptoAccount: json['cryptoAccount'] == null
          ? null
          : CryptoAccount.fromJson(
              json['cryptoAccount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ManageAccountsStateToJson(
        ManageAccountsState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'currentCryptoIndex': instance.currentCryptoIndex,
      'cryptoAccount': instance.cryptoAccount,
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
