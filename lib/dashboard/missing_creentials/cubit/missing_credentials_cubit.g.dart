// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missing_credentials_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissingCredentialsState _$MissingCredentialsStateFromJson(
        Map<String, dynamic> json) =>
    MissingCredentialsState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      dummyCredentials: (json['dummyCredentials'] as List<dynamic>?)
          ?.map((e) =>
              DiscoverDummyCredential.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MissingCredentialsStateToJson(
        MissingCredentialsState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'dummyCredentials': instance.dummyCredentials,
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
};
