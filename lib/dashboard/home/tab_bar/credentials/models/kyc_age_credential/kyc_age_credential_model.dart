import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kyc_age_credential_model.g.dart';

@JsonSerializable(explicitToJson: true)
class KYCAgeCredentialModel extends CredentialSubjectModel {
  KYCAgeCredentialModel({
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
    this.birthday,
    this.documentType,
  }) : super(
          credentialSubjectType: CredentialSubjectType.kycAgeCredential,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory KYCAgeCredentialModel.fromJson(Map<String, dynamic> json) =>
      _$KYCAgeCredentialModelFromJson(json);

  final int? birthday;
  final int? documentType;

  @override
  Map<String, dynamic> toJson() => _$KYCAgeCredentialModelToJson(this);
}
