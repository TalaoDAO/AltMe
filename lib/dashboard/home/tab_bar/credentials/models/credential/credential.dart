import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential/evidence.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential/proof.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_status_field/credential_status_field.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/default_credential_subject/default_credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential.g.dart';

@JsonSerializable(explicitToJson: true)
class Credential {
  Credential(
    this.id,
    this.context,
    this.type,
    this.issuer,
    this.expirationDate,
    this.issuanceDate,
    this.proof,
    this.credentialSubjectModel,
    this.description,
    this.name,
    this.credentialStatus,
    this.evidence,
  );

  factory Credential.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'VerifiableCredential') {
      return Credential.dummy();
    }
    return _$CredentialFromJson(json);
  }

  factory Credential.dummy() {
    return Credential(
      'dummy',
      ['dummy'],
      ['dummy'],
      'dummy',
      'dummy',
      'dummy',
      [
        Proof.dummy(),
      ],
      DefaultCredentialSubjectModel(
        id: 'dummy7',
        type: 'dummy8',
        issuedBy: const Author(''),
      ),
      [Translation('en', '')],
      [Translation('en', '')],
      CredentialStatusField.emptyCredentialStatusField(),
      [Evidence.emptyEvidence()],
    );
  }

  final String id;
  @JsonKey(name: '@context')
  final List<dynamic>? context;
  final List<String> type;
  final String issuer;
  @JsonKey(fromJson: _fromJsonTranslations)
  final List<Translation> description;
  @JsonKey(defaultValue: <Translation>[])
  final List<Translation> name;
  @JsonKey(defaultValue: '')
  final String expirationDate;
  @JsonKey(defaultValue: '')
  final String issuanceDate;
  @JsonKey(fromJson: _fromJsonProofs)
  final List<Proof> proof;
  @JsonKey(name: 'credentialSubject')
  final CredentialSubjectModel credentialSubjectModel;
  @JsonKey(fromJson: _fromJsonEvidence)
  final List<Evidence> evidence;
  @JsonKey(fromJson: _fromJsonCredentialStatus)
  final CredentialStatusField credentialStatus;

  Map<String, dynamic> toJson() => _$CredentialToJson(this);

  Credential copyWith({
    String? id,
    List<dynamic>? context,
    List<String>? type,
    String? issuer,
    String? expirationDate,
    String? issuanceDate,
    List<Proof>? proof,
    CredentialSubjectModel? credentialSubjectModel,
    List<Translation>? description,
    List<Translation>? name,
    CredentialStatusField? credentialStatus,
    List<Evidence>? evidence,
  }) {
    return Credential(
      id ?? this.id,
      context ?? this.context,
      type ?? this.type,
      issuer ?? this.issuer,
      expirationDate ?? this.expirationDate,
      issuanceDate ?? this.issuanceDate,
      proof ?? this.proof,
      credentialSubjectModel ?? this.credentialSubjectModel,
      description ?? this.description,
      name ?? this.name,
      credentialStatus ?? this.credentialStatus,
      evidence ?? this.evidence,
    );
  }

  static List<Proof> _fromJsonProofs(dynamic json) {
    if (json == null) {
      return [Proof.dummy()];
    }
    if (json is List) {
      return json
          .map((dynamic e) => Proof.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Proof.fromJson(json as Map<String, dynamic>)];
  }

  static List<Translation> _fromJsonTranslations(dynamic json) {
    if (json == null || json == '') {
      return [];
    }
    if (json is List) {
      return json
          .map((dynamic e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Translation.fromJson(json as Map<String, dynamic>)];
  }

  static CredentialStatusField _fromJsonCredentialStatus(dynamic json) {
    if (json == null || json == '') {
      return CredentialStatusField.emptyCredentialStatusField();
    }
    return CredentialStatusField.fromJson(json as Map<String, dynamic>);
  }

  static List<Evidence> _fromJsonEvidence(dynamic json) {
    if (json == null) {
      return [Evidence.emptyEvidence()];
    }
    if (json is List) {
      return json
          .map((dynamic e) => Evidence.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Evidence.fromJson(json as Map<String, dynamic>)];
  }

  static Credential fromJsonOrDummy(Map<String, dynamic> data) {
    try {
      return Credential.fromJson(data);
    } catch (e) {
      return Credential.dummy();
    }
  }
}
