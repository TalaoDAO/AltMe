import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PhonePassModel extends CredentialSubjectModel {
  PhonePassModel({
    this.expires,
    this.phone,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.phonePass,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory PhonePassModel.fromJson(Map<String, dynamic> json) =>
      _$PhonePassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  @JsonKey(defaultValue: '')
  final String? phone;

  @override
  Map<String, dynamic> toJson() => _$PhonePassModelToJson(this);
}
