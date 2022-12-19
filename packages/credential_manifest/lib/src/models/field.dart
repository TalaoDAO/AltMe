import 'package:credential_manifest/src/models/filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'field.g.dart';

@JsonSerializable(explicitToJson: true)
class Field {
  const Field({
    required this.path,
    this.filter,
    this.optional = false,
  });

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  final List<String> path;
  final Filter? filter;
  @JsonKey(defaultValue: false)
  final bool optional;

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}
