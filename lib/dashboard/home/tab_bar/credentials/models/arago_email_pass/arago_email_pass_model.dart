import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arago_email_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AragoEmailPassModel extends CredentialSubjectModel {
  AragoEmailPassModel({
    this.expires,
    this.email,
    String? id,
    String? type,
    Author? issuedBy,
    this.passbaseMetadata,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.aragoEmailPass,
          credentialCategory: CredentialCategory.identityCards,
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
