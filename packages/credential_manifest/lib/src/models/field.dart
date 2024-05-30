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

  // The fields object MAY contain an optional property.
  // The value of this property MUST be a boolean, wherein true indicates
  // the field is optional, and false or non-presence of the property indicates
  // the field is required. Even when the optional property is present,
  // the value located at the indicated path of the field MUST validate against
  // the JSON Schema filter, if a filter is present.
  @JsonKey(defaultValue: false)
  final bool optional;

  Map<String, dynamic> toJson() => _$FieldToJson(this);

  Field copyWith({
    List<String>? path,
    Filter? filter,
    bool? optional,
  }) {
    return Field(
      path: path ?? this.path,
      filter: filter ?? this.filter,
      optional: optional ?? this.optional,
    );
  }
}
