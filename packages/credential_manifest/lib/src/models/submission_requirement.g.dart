// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_requirement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionRequirement _$SubmissionRequirementFromJson(
  Map<String, dynamic> json,
) => SubmissionRequirement(
  name: json['name'] as String?,
  rule: json['rule'] as String?,
  count: (json['count'] as num?)?.toInt(),
  min: (json['min'] as num?)?.toInt(),
  from: json['from'] as String?,
);

Map<String, dynamic> _$SubmissionRequirementToJson(
  SubmissionRequirement instance,
) => <String, dynamic>{
  'name': instance.name,
  'rule': instance.rule,
  'count': instance.count,
  'min': instance.min,
  'from': instance.from,
};
