import 'package:json_annotation/json_annotation.dart';

part 'signature.g.dart';

@JsonSerializable(explicitToJson: true)
class Signature {
  Signature(this.image, this.jobTitle, this.name);

  factory Signature.fromJson(Map<String, dynamic> json) =>
      _$SignatureFromJson(json);

  factory Signature.emptySignature() => Signature('', '', '');

  Map<String, dynamic> toJson() => _$SignatureToJson(this);

  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: '')
  final String jobTitle;
  @JsonKey(defaultValue: '')
  final String name;
}
