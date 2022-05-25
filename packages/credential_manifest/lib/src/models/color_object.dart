import 'package:json_annotation/json_annotation.dart';

part 'color_object.g.dart';

/// This object is to get background & text color of displayed credentials
@JsonSerializable(explicitToJson: true)
class ColorObject {
  ///Initializes [color] for class
  ColorObject(this.color);

  /// Create object from json definition
  factory ColorObject.fromJson(Map<String, dynamic> json) =>
      _$ColorObjectFromJson(json);

  /// color property which is a HEX string color value
  final String? color;

  /// Create json object from instance
  Map<String, dynamic> toJson() => _$ColorObjectToJson(this);
}
