// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_receive_home_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendReceiveHomeState _$SendReceiveHomeStateFromJson(
  Map<String, dynamic> json,
) => SendReceiveHomeState(
  operations:
      (json['operations'] as List<dynamic>?)
          ?.map((e) => OperationModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  selectedToken: TokenModel.fromJson(
    json['selectedToken'] as Map<String, dynamic>,
  ),
  status:
      $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ?? AppStatus.init,
  message: json['message'] == null
      ? null
      : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SendReceiveHomeStateToJson(
  SendReceiveHomeState instance,
) => <String, dynamic>{
  'operations': instance.operations,
  'selectedToken': instance.selectedToken,
  'status': _$AppStatusEnumMap[instance.status]!,
  'message': instance.message,
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
