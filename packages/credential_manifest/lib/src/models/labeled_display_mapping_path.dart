import 'package:credential_manifest/src/models/display_mapping.dart';
import 'package:credential_manifest/src/models/schema.dart';
import 'package:json_annotation/json_annotation.dart';

part 'labeled_display_mapping_path.g.dart';

/// This object is to display data from a jsonPath with a label
@JsonSerializable(explicitToJson: true)
class LabeledDisplayMappingPath extends DisplayMapping {
  /// Initialize [path], [schema], [fallback], [label] for class
  LabeledDisplayMappingPath(this.path, this.schema, this.fallback, this.label);

  /// Create object from json definition
  factory LabeledDisplayMappingPath.fromJson(Map<String, dynamic> json) =>
      _$LabeledDisplayMappingPathFromJson(json);

  /// Label of the property to display
  final String label;

  /// JsonPath to displayed data
  final List<String> path;

  /// [Schema] of the data to display which defines its type
  final Schema schema;

  /// Value to display if jsonPath doesn't return any data
  final String? fallback;

  /// Create json object from instance
  @override
  Map<String, dynamic> toJson() => _$LabeledDisplayMappingPathToJson(this);
}
