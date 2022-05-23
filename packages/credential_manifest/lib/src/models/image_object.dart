import 'package:json_annotation/json_annotation.dart';

part 'image_object.g.dart';

/// This object is used to display images
@JsonSerializable(explicitToJson: true)
class ImageObject {
  /// Initialize [uri] and [alt] for class
  ImageObject(this.uri, this.alt);

  /// Create object from json definition
  factory ImageObject.fromJson(Map<String, dynamic> json) =>
      _$ImageObjectFromJson(json);

  /// url of the image
  final String uri;

  /// Alt text of the image
  final String? alt;

  /// Create json object from instance
  Map<String, dynamic> toJson() => _$ImageObjectToJson(this);
}
