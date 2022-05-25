import 'package:credential_manifest/src/models/display_mapping.dart';
import 'package:json_annotation/json_annotation.dart';

part 'labeled_display_mapping_text.g.dart';

/// This object is to display constant text with with a label
@JsonSerializable(explicitToJson: true)
class LabeledDisplayMappingText extends DisplayMapping {
  /// Initialize [text] and [label] for class
  LabeledDisplayMappingText(this.text, this.label);

  /// Create object from json definition
  factory LabeledDisplayMappingText.fromJson(Map<String, dynamic> json) =>
      _$LabeledDisplayMappingTextFromJson(json);

  /// Label of the property to display
  final String label;

  /// Text of the property to display
  final String text;

  /// Create json object from instance
  @override
  Map<String, dynamic> toJson() => _$LabeledDisplayMappingTextToJson(this);
}
