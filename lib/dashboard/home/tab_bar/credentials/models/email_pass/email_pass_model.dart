import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EmailPassModel extends CredentialSubjectModel {
  EmailPassModel({
    this.expires,
    this.email,
    super.id,
    super.type,
    super.issuedBy,
    this.passbaseMetadata,
  }) : super(
          credentialSubjectType: CredentialSubjectType.emailPass,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory EmailPassModel.fromJson(Map<String, dynamic> json) =>
      _$EmailPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  @JsonKey(defaultValue: '')
  final String? email;
  @JsonKey(defaultValue: '')
  final String? passbaseMetadata;

  @override
  Map<String, dynamic> toJson() => _$EmailPassModelToJson(this);
}
