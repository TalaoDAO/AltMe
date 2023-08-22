import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_credential_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeCredentialModel extends CredentialSubjectModel {
  EmployeeCredentialModel({
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.employeeCredential,
          credentialCategory: CredentialCategory.professionalCards,
        );

  factory EmployeeCredentialModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeCredentialModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmployeeCredentialModelToJson(this);
}
