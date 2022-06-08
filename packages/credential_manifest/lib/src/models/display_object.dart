import 'package:credential_manifest/src/models/display_mapping.dart';
import 'package:credential_manifest/src/models/display_mapping_path.dart';
import 'package:credential_manifest/src/models/display_mapping_text.dart';
import 'package:credential_manifest/src/models/labeled_display_mapping_path.dart';
import 'package:credential_manifest/src/models/labeled_display_mapping_text.dart';
import 'package:json_annotation/json_annotation.dart';

part 'display_object.g.dart';

/// This object regroup a set of instructions to display VC data
@JsonSerializable(explicitToJson: true)
class DisplayObject {
  /// Initialize non mandatory instructions to display [title], [subtitle],
  /// [description] and [properties] of credential.
  DisplayObject(this.title, this.subtitle, this.description, this.properties);

  /// Create object from json definition
  factory DisplayObject.fromJson(Map<String, dynamic> json) =>
      _$DisplayObjectFromJson(json);

  /// definition of the [title] to display, if any
  @JsonKey(fromJson: _displayMappingFromJson)
  final DisplayMapping? title;

  /// definition of the [subtitle] to display, if any
  @JsonKey(fromJson: _displayMappingFromJson)
  final DisplayMapping? subtitle;

  /// definition of the [description] to display, if any
  @JsonKey(fromJson: _displayMappingFromJson)
  final DisplayMapping? description;

  /// definition of the [properties] to display, if any
  @JsonKey(fromJson: _labeledDisplayMappingFromJson)
  final List<DisplayMapping>? properties;

  /// Create json object from instance
  Map<String, dynamic> toJson() => _$DisplayObjectToJson(this);

  static List<DisplayMapping>? _labeledDisplayMappingFromJson(
    dynamic json,
  ) {
    if (json is List<dynamic>) {
      return json.map((dynamic e) {
        if (e['text'] == null) {
          return LabeledDisplayMappingPath.fromJson(e as Map<String, dynamic>);
        }
        return LabeledDisplayMappingText.fromJson(e as Map<String, dynamic>);
      }).toList();
    }
    return null;
  }

  static DisplayMapping? _displayMappingFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    if (json['text'] == null) {
      return DisplayMappingPath.fromJson(json);
    }
    return DisplayMappingText.fromJson(json);
  }
}
