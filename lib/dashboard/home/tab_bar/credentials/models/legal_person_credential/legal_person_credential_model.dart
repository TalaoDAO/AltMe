import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_person_credential_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LegalPersonCredentialModel extends CredentialSubjectModel {
  LegalPersonCredentialModel({
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
         credentialSubjectType: CredentialSubjectType.legalPersonalCredential,
         credentialCategory: CredentialCategory.professionalCards,
       );

  factory LegalPersonCredentialModel.fromJson(Map<String, dynamic> json) =>
      _$LegalPersonCredentialModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LegalPersonCredentialModelToJson(this);
}
