import 'package:json_annotation/json_annotation.dart';

part 'submission_requirement.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionRequirement {
  SubmissionRequirement({
    this.name,
    this.rule,
    this.count,
    this.min,
    this.from,
  });

  factory SubmissionRequirement.fromJson(Map<String, dynamic> json) =>
      _$SubmissionRequirementFromJson(json);

  String? name;
  String? rule;
  int? count;
  int? min;
  String? from;

  Map<String, dynamic> toJson() => _$SubmissionRequirementToJson(this);
}
