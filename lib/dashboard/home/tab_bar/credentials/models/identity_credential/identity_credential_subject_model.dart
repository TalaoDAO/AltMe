import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'identity_credential_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class IdentityCredentialSubjectModel extends CredentialSubjectModel {
  IdentityCredentialSubjectModel({super.id, super.type, super.issuedBy})
    : super(
        credentialSubjectType: CredentialSubjectType.identityCredential,
        credentialCategory: CredentialCategory.identityCards,
      );

  factory IdentityCredentialSubjectModel.fromJson(Map<String, dynamic> json) =>
      _$IdentityCredentialSubjectModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IdentityCredentialSubjectModelToJson(this);
}
