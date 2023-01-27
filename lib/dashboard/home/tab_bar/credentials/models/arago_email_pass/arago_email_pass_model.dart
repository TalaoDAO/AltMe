import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arago_email_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AragoEmailPassModel extends CredentialSubjectModel {
  AragoEmailPassModel({
    this.expires,
    this.email,
    super.id,
    super.type,
    super.issuedBy,
    this.passbaseMetadata,
  }) : super(
          credentialSubjectType: CredentialSubjectType.aragoEmailPass,
          credentialCategory: CredentialCategory.passCards,
        );

  factory AragoEmailPassModel.fromJson(Map<String, dynamic> json) =>
      _$AragoEmailPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  @JsonKey(defaultValue: '')
  final String? email;
  @JsonKey(defaultValue: '')
  final String? passbaseMetadata;

  @override
  Map<String, dynamic> toJson() => _$AragoEmailPassModelToJson(this);
}
