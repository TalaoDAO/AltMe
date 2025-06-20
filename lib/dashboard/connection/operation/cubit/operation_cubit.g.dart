// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationState _$OperationStateFromJson(Map<String, dynamic> json) =>
    OperationState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      amount: json['amount'] as String? ?? '0',
      totalFee: json['totalFee'] as String? ?? '0',
      bakerFee: json['bakerFee'] as String?,
      usdRate: (json['usdRate'] as num?)?.toDouble() ?? 0,
      cryptoAccountData: json['cryptoAccountData'] == null
          ? null
          : CryptoAccountData.fromJson(
              json['cryptoAccountData'] as Map<String, dynamic>),
      dAppName: json['dAppName'] as String? ?? '',
    );

Map<String, dynamic> _$OperationStateToJson(OperationState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'amount': instance.amount,
      'totalFee': instance.totalFee,
      'bakerFee': instance.bakerFee,
      'usdRate': instance.usdRate,
      'cryptoAccountData': instance.cryptoAccountData,
      'dAppName': instance.dAppName,
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
