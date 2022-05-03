import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

@JsonSerializable(explicitToJson: true)
class Skill {
  Skill(this.type, this.description);

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  @JsonKey(defaultValue: '', name: '@type')
  final String type;
  @JsonKey(defaultValue: '')
  final String description;

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
