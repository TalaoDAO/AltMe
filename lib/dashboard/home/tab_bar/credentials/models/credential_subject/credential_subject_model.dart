import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialSubjectModel {
  CredentialSubjectModel({
    this.id,
    this.type,
    this.issuedBy,
    this.offeredBy,
    required this.credentialSubjectType,
    required this.credentialCategory,
  });

  factory CredentialSubjectModel.fromJson(Map<String, dynamic> json) {
    for (final element in CredentialSubjectType.values) {
      if (json['type'] == element.name) {
        return element.modelFromJson(json);
      }
    }
    return CredentialSubjectType.defaultCredential.modelFromJson(json);
  }

  final String? id;
  final dynamic type;
  @JsonKey(fromJson: fromJsonAuthor)
  final Author? issuedBy;
  @JsonKey(fromJson: fromJsonAuthor, includeIfNull: false)
  final Author? offeredBy;
  final CredentialSubjectType credentialSubjectType;
  final CredentialCategory credentialCategory;

  CredentialSubjectModel copyWith({
    String? id,
    dynamic type,
    Author? issuedBy,
    Author? offeredBy,
    CredentialSubjectType? credentialSubjectType,
    CredentialCategory? credentialCategory,
  }) {
    return CredentialSubjectModel(
      id: id ?? this.id,
      type: type ?? this.type,
      issuedBy: issuedBy ?? this.issuedBy,
      offeredBy: offeredBy ?? this.offeredBy,
      credentialSubjectType:
          credentialSubjectType ?? this.credentialSubjectType,
      credentialCategory: credentialCategory ?? this.credentialCategory,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialSubjectModelToJson(this);

  static Author fromJsonAuthor(dynamic json) {
    if (json == null || json == '') {
      return const Author('');
    }
    return Author.fromJson(json as Map<String, dynamic>);
  }
}
