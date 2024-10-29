// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_dapp_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedDappData _$SavedDappDataFromJson(Map<String, dynamic> json) =>
    SavedDappData(
      peer: json['peer'] == null
          ? null
          : P2PPeer.fromJson(json['peer'] as Map<String, dynamic>),
      walletAddress: json['walletAddress'] as String?,
      sessionData: json['sessionData'] == null
          ? null
          : SessionData.fromJson(json['sessionData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SavedDappDataToJson(SavedDappData instance) =>
    <String, dynamic>{
      'peer': instance.peer,
      'walletAddress': instance.walletAddress,
      'sessionData': instance.sessionData,
    };
