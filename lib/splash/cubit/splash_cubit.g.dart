// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SplashState _$SplashStateFromJson(Map<String, dynamic> json) => SplashState(
      status: $enumDecodeNullable(_$SplashStatusEnumMap, json['status']) ??
          SplashStatus.init,
      versionNumber: json['versionNumber'] as String? ?? '',
      buildNumber: json['buildNumber'] as String? ?? '',
      isNewVersion: json['isNewVersion'] as bool? ?? false,
      loadedValue: (json['loadedValue'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$SplashStateToJson(SplashState instance) =>
    <String, dynamic>{
      'status': _$SplashStatusEnumMap[instance.status]!,
      'versionNumber': instance.versionNumber,
      'buildNumber': instance.buildNumber,
      'isNewVersion': instance.isNewVersion,
      'loadedValue': instance.loadedValue,
    };

const _$SplashStatusEnumMap = {
  SplashStatus.init: 'init',
  SplashStatus.routeToPassCode: 'routeToPassCode',
  SplashStatus.routeToOnboarding: 'routeToOnboarding',
  SplashStatus.idle: 'idle',
  SplashStatus.authenticated: 'authenticated',
};
