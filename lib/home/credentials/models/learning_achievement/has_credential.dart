import 'package:json_annotation/json_annotation.dart';

part 'has_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class HasCredential {
  HasCredential(this.title, this.description);

  factory HasCredential.fromJson(Map<String, dynamic> json) =>
      _$HasCredentialFromJson(json);

  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String description;

  Map<String, dynamic> toJson() => _$HasCredentialToJson(this);
}
