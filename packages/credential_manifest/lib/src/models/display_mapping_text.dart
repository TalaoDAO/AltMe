import 'package:credential_manifest/src/models/display_mapping.dart';
import 'package:json_annotation/json_annotation.dart';

part 'display_mapping_text.g.dart';

/// This object define a field to be displayed
@JsonSerializable(explicitToJson: true)
class DisplayMappingText extends DisplayMapping {
  /// Initialize [text]
  DisplayMappingText(this.text);

  /// Create object from json definition
  factory DisplayMappingText.fromJson(Map<String, dynamic> json) =>
      _$DisplayMappingTextFromJson(json);

  /// text to be displayed
  final String text;

  /// Create json object from instance
  @override
  Map<String, dynamic> toJson() => _$DisplayMappingTextToJson(this);
}
