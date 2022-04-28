import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/credential_subject/credential_subject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_credential_subject.g.dart';

@JsonSerializable(explicitToJson: true)
class DefaultCredentialSubject extends CredentialSubject {
  DefaultCredentialSubject(this.id, this.type, this.issuedBy)
      : super(id, type, issuedBy);

  factory DefaultCredentialSubject.fromJson(Map<String, dynamic> json) =>
      _$DefaultCredentialSubjectFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;

  @override
  Map<String, dynamic> toJson() => _$DefaultCredentialSubjectToJson(this);
}
