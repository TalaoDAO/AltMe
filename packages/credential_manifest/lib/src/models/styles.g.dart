// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'styles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Styles _$StylesFromJson(Map<String, dynamic> json) => Styles(
      json['thumbnail'] == null
          ? null
          : ImageObject.fromJson(json['thumbnail'] as Map<String, dynamic>),
      json['hero'] == null
          ? null
          : ImageObject.fromJson(json['hero'] as Map<String, dynamic>),
      json['background'] == null
          ? null
          : ColorObject.fromJson(json['background'] as Map<String, dynamic>),
      json['text'] == null
          ? null
          : ColorObject.fromJson(json['text'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StylesToJson(Styles instance) => <String, dynamic>{
      'thumbnail': instance.thumbnail?.toJson(),
      'hero': instance.hero?.toJson(),
      'background': instance.background?.toJson(),
      'text': instance.text?.toJson(),
    };
