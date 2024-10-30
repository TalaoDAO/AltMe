// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      acquisitionAt: json['acquisitionAt'] == null
          ? null
          : DateTime.parse(json['acquisitionAt'] as String),
      presentation: json['presentation'] == null
          ? null
          : Presentation.fromJson(json['presentation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'acquisitionAt': instance.acquisitionAt?.toIso8601String(),
      'presentation': instance.presentation,
    };

Presentation _$PresentationFromJson(Map<String, dynamic> json) => Presentation(
      issuer: Issuer.fromJson(json['issuer'] as Map<String, dynamic>),
      presentedAt: DateTime.parse(json['presentedAt'] as String),
    );

Map<String, dynamic> _$PresentationToJson(Presentation instance) =>
    <String, dynamic>{
      'issuer': instance.issuer,
      'presentedAt': instance.presentedAt.toIso8601String(),
    };
