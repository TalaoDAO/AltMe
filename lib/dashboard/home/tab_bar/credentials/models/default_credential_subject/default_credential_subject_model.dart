import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_credential_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DefaultCredentialSubjectModel extends CredentialSubjectModel {
  DefaultCredentialSubjectModel(String? id, String? type, Author? issuedBy)
      : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.defaultCredential,
          credentialCategory: CredentialCategory.othersCards,
        );

  factory DefaultCredentialSubjectModel.fromJson(Map<String, dynamic> json) =>
      _$DefaultCredentialSubjectModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DefaultCredentialSubjectModelToJson(this);
}
