// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_dapps_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectedDappsState _$ConnectedDappsStateFromJson(Map<String, dynamic> json) =>
    ConnectedDappsState(
      status:
          $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      xtzModel: json['xtzModel'] == null
          ? null
          : TokenModel.fromJson(json['xtzModel'] as Map<String, dynamic>),
      savedDapps: (json['savedDapps'] as List<dynamic>?)
          ?.map((e) => SavedDappData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConnectedDappsStateToJson(
  ConnectedDappsState instance,
) => <String, dynamic>{
  'status': _$AppStatusEnumMap[instance.status]!,
  'message': instance.message,
  'xtzModel': instance.xtzModel,
  'savedDapps': instance.savedDapps,
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
