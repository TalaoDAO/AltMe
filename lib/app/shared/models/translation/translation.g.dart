// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Translation _$TranslationFromJson(Map<String, dynamic> json) => Translation(
      json['@language'] as String? ?? 'en',
      json['@value'] as String? ?? '',
    );

Map<String, dynamic> _$TranslationToJson(Translation instance) =>
    <String, dynamic>{
      '@language': instance.language,
      '@value': instance.value,
    };
