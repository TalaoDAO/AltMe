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
  final String? type;
  @JsonKey(fromJson: fromJsonAuthor)
  final Author? issuedBy;
  final CredentialSubjectType credentialSubjectType;
  final CredentialCategory credentialCategory;

  Map<String, dynamic> toJson() => _$CredentialSubjectModelToJson(this);

  static Author fromJsonAuthor(dynamic json) {
    if (json == null || json == '') {
      return const Author('');
    }
    return Author.fromJson(json as Map<String, dynamic>);
  }
}
