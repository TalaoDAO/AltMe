import 'package:json_annotation/json_annotation.dart';

part 'work_for.g.dart';

@JsonSerializable()
class WorkFor {
  WorkFor(this.address, this.logo, this.name);

  factory WorkFor.fromJson(Map<String, dynamic> json) =>
      _$WorkForFromJson(json);

  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String logo;
  @JsonKey(defaultValue: '')
  final String name;

  Map<String, dynamic> toJson() => _$WorkForToJson(this);
}
