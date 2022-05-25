import 'package:credential_manifest/src/models/color_object.dart';
import 'package:credential_manifest/src/models/image_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'styles.g.dart';

/// Entity Style Descriptors are a resource format that defines
/// a set of suggested visual styling elements that a consuming party MAY apply
/// to their presentation of associated entities.
@JsonSerializable(explicitToJson: true)
class Styles {
  /// Initilize [thumbnail], [hero], [background], [text]
  Styles(this.thumbnail, this.hero, this.background, this.text);

  /// Create object from json definition
  factory Styles.fromJson(Map<String, dynamic> json) => _$StylesFromJson(json);

  /// Define url of Thumbnail and alt text
  final ImageObject? thumbnail;

  /// Define url of hero and alt text
  final ImageObject? hero;

  /// Define color of the background
  final ColorObject? background;

  /// Define color of texts
  final ColorObject? text;

  /// Create json object from instance
  Map<String, dynamic> toJson() => _$StylesToJson(this);
}
