import 'package:json_annotation/json_annotation.dart';

part 'has_credential_ecole_42.g.dart';

@JsonSerializable(explicitToJson: true)
class HasCredentialEcole42 {
  HasCredentialEcole42(
    this.title,
    this.description,
    this.level,
    this.inDefinedTermSet,
  );

  factory HasCredentialEcole42.fromJson(Map<String, dynamic> json) =>
      _$HasCredentialEcole42FromJson(json);

  factory HasCredentialEcole42.emptyCredential() =>
      HasCredentialEcole42('', '', '', '');
  Map<String, dynamic> toJson() => _$HasCredentialEcole42ToJson(this);

  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: '')
  final String level;
  @JsonKey(defaultValue: '')
  final String inDefinedTermSet;
}
