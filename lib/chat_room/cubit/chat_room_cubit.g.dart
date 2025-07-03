// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomState _$ChatRoomStateFromJson(Map<String, dynamic> json) =>
    ChatRoomState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.idle,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Message>[],
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatRoomStateToJson(ChatRoomState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'messages': instance.messages,
      'message': instance.message,
      'user': instance.user,
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
