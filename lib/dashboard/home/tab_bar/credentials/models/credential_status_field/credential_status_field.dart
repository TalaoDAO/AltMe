import 'package:json_annotation/json_annotation.dart';

part 'credential_status_field.g.dart';

@JsonSerializable()
class CredentialStatusField {
  CredentialStatusField(
    this.id,
    this.type,
    this.revocationListIndex,
    this.revocationListCredential,
    this.statusListCredential,
    this.statusListIndex,
    this.statusPurpose,
  );

  factory CredentialStatusField.fromJson(Map<String, dynamic> json) =>
      _$CredentialStatusFieldFromJson(json);

  factory CredentialStatusField.emptyCredentialStatusField() =>
      CredentialStatusField('', '', '', '', '', '', '');

  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: '')
  final String revocationListIndex;
  @JsonKey(defaultValue: '')
  final String revocationListCredential;
  final String statusListCredential;
  @JsonKey(defaultValue: '')
  final String statusListIndex;
  @JsonKey(defaultValue: '')
  final String statusPurpose;

  Map<String, dynamic> toJson() => _$CredentialStatusFieldToJson(this);
}
