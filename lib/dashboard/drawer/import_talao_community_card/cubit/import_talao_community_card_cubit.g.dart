// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_talao_community_card_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportTalaoCommunityCardState _$ImportTalaoCommunityCardStateFromJson(
        Map<String, dynamic> json) =>
    ImportTalaoCommunityCardState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      isTextFieldEdited: json['isTextFieldEdited'] as bool? ?? false,
      isPrivateKeyValid: json['isPrivateKeyValid'] as bool? ?? false,
    );

Map<String, dynamic> _$ImportTalaoCommunityCardStateToJson(
        ImportTalaoCommunityCardState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'isTextFieldEdited': instance.isTextFieldEdited,
      'isPrivateKeyValid': instance.isPrivateKeyValid,
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
