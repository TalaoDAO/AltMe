// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polygon_id_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolygonIdState _$PolygonIdStateFromJson(Map<String, dynamic> json) =>
    PolygonIdState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      polygonAction:
          $enumDecodeNullable(_$PolygonIdActionEnumMap, json['polygonAction']),
      isInitialised: json['isInitialised'] as bool? ?? false,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      scannedResponse: json['scannedResponse'] as String?,
      claims: (json['claims'] as List<dynamic>?)
          ?.map((e) => ClaimEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      credentialManifests: (json['credentialManifests'] as List<dynamic>?)
          ?.map((e) => CredentialManifest.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentNetwork: $enumDecodeNullable(
              _$PolygonIdNetworkEnumMap, json['currentNetwork']) ??
          PolygonIdNetwork.PolygonMainnet,
    );

Map<String, dynamic> _$PolygonIdStateToJson(PolygonIdState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'polygonAction': _$PolygonIdActionEnumMap[instance.polygonAction],
      'message': instance.message,
      'isInitialised': instance.isInitialised,
      'scannedResponse': instance.scannedResponse,
      'claims': instance.claims,
      'credentialManifests': instance.credentialManifests,
      'currentNetwork': _$PolygonIdNetworkEnumMap[instance.currentNetwork]!,
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

const _$PolygonIdActionEnumMap = {
  PolygonIdAction.issuer: 'issuer',
  PolygonIdAction.verifier: 'verifier',
  PolygonIdAction.offer: 'offer',
  PolygonIdAction.contractFunctionCall: 'contractFunctionCall',
};

const _$PolygonIdNetworkEnumMap = {
  PolygonIdNetwork.PolygonMainnet: 'PolygonMainnet',
  PolygonIdNetwork.PolygonMumbai: 'PolygonMumbai',
};
