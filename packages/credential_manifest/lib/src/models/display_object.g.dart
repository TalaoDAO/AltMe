// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayObject _$DisplayObjectFromJson(Map<String, dynamic> json) =>
    DisplayObject(
      DisplayObject._displayMappingFromJson(
          json['title'] as Map<String, dynamic>?),
      DisplayObject._displayMappingFromJson(
          json['subtitle'] as Map<String, dynamic>?),
      DisplayObject._displayMappingFromJson(
          json['description'] as Map<String, dynamic>?),
      DisplayObject._labeledDisplayMappingFromJson(json['properties']),
    );

Map<String, dynamic> _$DisplayObjectToJson(DisplayObject instance) =>
    <String, dynamic>{
      'title': instance.title?.toJson(),
      'subtitle': instance.subtitle?.toJson(),
      'description': instance.description?.toJson(),
      'properties': instance.properties?.map((e) => e.toJson()).toList(),
    };
