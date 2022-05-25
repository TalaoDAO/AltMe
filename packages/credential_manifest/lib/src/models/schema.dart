import 'package:json_annotation/json_annotation.dart';

part 'schema.g.dart';

/// This object is used to describe the type of data to be display
@JsonSerializable(explicitToJson: true)
class Schema {
  /// Initialyze object with [type] and [format]
  Schema(this.type, this.format);

  /// Create object from json definition
  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  /// its value must be “string”, “boolean”, “number”, or “integer”.
  final String type;

  /// Exist IF the type property is "string" and its value must be “date-time”,
  ///  “time”, “date”, “email”, “idn-email”, “hostname”, “idn-hostname”, “ipv4”,
  ///  “ipv6”, “uri”, “uri-reference”, “iri”, or “iri-reference”.
  /// This property is to be used to transform the property in the rendered UI,
  /// for example tranforming an ISO Date string into a human readable string.
  final String? format;

  /// Create json object from instance
  Map<String, dynamic> toJson() => _$SchemaToJson(this);
}
