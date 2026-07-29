// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_amount_calculator_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenAmountCalculatorState _$TokenAmountCalculatorStateFromJson(
  Map<String, dynamic> json,
) => TokenAmountCalculatorState(
  validAmount: json['validAmount'] as String? ?? '0',
  insertedAmount: json['insertedAmount'] as String? ?? '',
  status:
      $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ?? AppStatus.idle,
);

Map<String, dynamic> _$TokenAmountCalculatorStateToJson(
  TokenAmountCalculatorState instance,
) => <String, dynamic>{
  'validAmount': instance.validAmount,
  'insertedAmount': instance.insertedAmount,
  'status': _$AppStatusEnumMap[instance.status]!,
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
