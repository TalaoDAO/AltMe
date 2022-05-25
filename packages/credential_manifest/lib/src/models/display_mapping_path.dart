import 'package:credential_manifest/src/models/display_mapping.dart';
import 'package:credential_manifest/src/models/schema.dart';
import 'package:json_annotation/json_annotation.dart';

part 'display_mapping_path.g.dart';

/// This object define a field to be displayed
@JsonSerializable(explicitToJson: true)
class DisplayMappingPath extends DisplayMapping {
  /// Initializes [path], [schema] and [fallback]
  DisplayMappingPath(this.path, this.schema, this.fallback);

  /// Create object from json definition
  factory DisplayMappingPath.fromJson(Map<String, dynamic> json) =>
      _$DisplayMappingPathFromJson(json);

  /// List of jsonPath used to find values in the credential
  final List<String> path;

  /// Define the type of the data
  final Schema schema;

  /// Define fallback value if nothing is found with jsonPath
  final String? fallback;

  /// Create json object from instance
  @override
  Map<String, dynamic> toJson() => _$DisplayMappingPathToJson(this);
}
