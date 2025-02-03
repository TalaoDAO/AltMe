// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_details_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialDetailsState _$CredentialDetailsStateFromJson(
        Map<String, dynamic> json) =>
    CredentialDetailsState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      credentialStatus: $enumDecodeNullable(
          _$CredentialStatusEnumMap, json['credentialStatus']),
      credentialDetailTabStatus: $enumDecodeNullable(
              _$CredentialDetailTabStatusEnumMap,
              json['credentialDetailTabStatus']) ??
          CredentialDetailTabStatus.informations,
      statusListUrl: json['statusListUrl'] as String?,
      statusListIndex: (json['statusListIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CredentialDetailsStateToJson(
        CredentialDetailsState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'credentialStatus': _$CredentialStatusEnumMap[instance.credentialStatus],
      'credentialDetailTabStatus': _$CredentialDetailTabStatusEnumMap[
          instance.credentialDetailTabStatus]!,
      'statusListUrl': instance.statusListUrl,
      'statusListIndex': instance.statusListIndex,
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

const _$CredentialStatusEnumMap = {
  CredentialStatus.pending: 'pending',
  CredentialStatus.active: 'active',
  CredentialStatus.expired: 'expired',
  CredentialStatus.invalidSignature: 'invalidSignature',
  CredentialStatus.statusListInvalidSignature: 'statusListInvalidSignature',
  CredentialStatus.invalidStatus: 'invalidStatus',
  CredentialStatus.unknown: 'unknown',
  CredentialStatus.noStatus: 'noStatus',
};

const _$CredentialDetailTabStatusEnumMap = {
  CredentialDetailTabStatus.informations: 'informations',
  CredentialDetailTabStatus.activity: 'activity',
};
