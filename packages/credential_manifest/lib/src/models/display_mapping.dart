import 'package:json_annotation/json_annotation.dart';

part 'display_mapping.g.dart';

/// /// This object define a field to be displayed
@JsonSerializable(explicitToJson: true)
class DisplayMapping {
  ///
  DisplayMapping();

  /// Create object from json definition
  factory DisplayMapping.fromJson(Map<String, dynamic> json) =>
      _$DisplayMappingFromJson(json);

  /// Create json object from instance
  Map<String, dynamic> toJson() => _$DisplayMappingToJson(this);
}
