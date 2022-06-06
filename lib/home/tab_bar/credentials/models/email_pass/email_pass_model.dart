import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EmailPassModel extends CredentialSubjectModel {
  EmailPassModel({
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
