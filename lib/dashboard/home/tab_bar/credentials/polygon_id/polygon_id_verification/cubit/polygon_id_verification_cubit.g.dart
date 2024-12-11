// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polygon_id_verification_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolygonIdVerificationState _$PolygonIdVerificationStateFromJson(
        Map<String, dynamic> json) =>
    PolygonIdVerificationState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      canGenerateProof: json['canGenerateProof'] as bool? ?? false,
      claimEntities: (json['claimEntities'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ClaimEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PolygonIdVerificationStateToJson(
        PolygonIdVerificationState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'canGenerateProof': instance.canGenerateProof,
      'claimEntities': instance.claimEntities,
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
