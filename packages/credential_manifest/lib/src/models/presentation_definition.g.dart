// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresentationDefinition _$PresentationDefinitionFromJson(
        Map<String, dynamic> json) =>
    PresentationDefinition(
      inputDescriptors: (json['input_descriptors'] as List<dynamic>)
          .map((e) => InputDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
      name: json['name'] as String?,
      purpose: json['purpose'] as String?,
      submissionRequirements: (json['submission_requirements']
              as List<dynamic>?)
          ?.map(
              (e) => SubmissionRequirement.fromJson(e as Map<String, dynamic>))
          .toList(),
      format: json['format'] == null
          ? null
          : Format.fromJson(json['format'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PresentationDefinitionToJson(
        PresentationDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'input_descriptors':
          instance.inputDescriptors.map((e) => e.toJson()).toList(),
      'submission_requirements':
          instance.submissionRequirements?.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'purpose': instance.purpose,
      'format': instance.format?.toJson(),
    };
