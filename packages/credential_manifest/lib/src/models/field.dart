import 'package:credential_manifest/src/models/filter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'field.g.dart';

@JsonSerializable(explicitToJson: true)
class Field {
  Field(this.path, this.filter);

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  final List<String> path;
  final Filter? filter;

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}
