import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_credential_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DefaultCredentialSubjectModel extends CredentialSubjectModel {
  DefaultCredentialSubjectModel({
    super.id,
    super.type,
    super.issuedBy,
    super.credentialSubjectType = CredentialSubjectType.defaultCredential,
    super.credentialCategory = CredentialCategory.othersCards,
  });

  factory DefaultCredentialSubjectModel.fromJson(Map<String, dynamic> json) =>
      _$DefaultCredentialSubjectModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DefaultCredentialSubjectModelToJson(this);
}
