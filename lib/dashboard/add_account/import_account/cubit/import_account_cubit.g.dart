// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_account_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportAccountState _$ImportAccountStateFromJson(Map<String, dynamic> json) =>
    ImportAccountState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      isTextFieldEdited: json['isTextFieldEdited'] as bool? ?? false,
      isMnemonicOrKeyValid: json['isMnemonicOrKeyValid'] as bool? ?? false,
      accountType:
          $enumDecodeNullable(_$AccountTypeEnumMap, json['accountType']) ??
              AccountType.tezos,
    );

Map<String, dynamic> _$ImportAccountStateToJson(ImportAccountState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'isTextFieldEdited': instance.isTextFieldEdited,
      'isMnemonicOrKeyValid': instance.isMnemonicOrKeyValid,
      'accountType': _$AccountTypeEnumMap[instance.accountType]!,
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

const _$AccountTypeEnumMap = {
  AccountType.ssi: 'ssi',
  AccountType.tezos: 'tezos',
  AccountType.ethereum: 'ethereum',
  AccountType.fantom: 'fantom',
  AccountType.polygon: 'polygon',
  AccountType.binance: 'binance',
  AccountType.etherlink: 'etherlink',
};
