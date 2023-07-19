import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'civic_pass_credential_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CivicPassCredentialModel extends CredentialSubjectModel {
  CivicPassCredentialModel({
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.civicPassCredential,
          credentialCategory: CredentialCategory.polygonidCards,
        );

  factory CivicPassCredentialModel.fromJson(Map<String, dynamic> json) =>
      _$CivicPassCredentialModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CivicPassCredentialModelToJson(this);
}
