import 'package:altme/app/shared/enum/type/credential_subject_type/credential_subject_type.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/credentials/models/identity_pass/identity_pass_recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'identity_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class IdentityPassModel extends CredentialSubjectModel {
  IdentityPassModel({
    this.recipient,
    this.expires,
    Author? issuedBy,
    String? id,
    String? type,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.identityPass,
        );

  factory IdentityPassModel.fromJson(Map<String, dynamic> json) =>
      _$IdentityPassModelFromJson(json);

  final IdentityPassRecipient? recipient;
  @JsonKey(defaultValue: '')
  final String? expires;

  @override
  Map<String, dynamic> toJson() => _$IdentityPassModelToJson(this);
}
