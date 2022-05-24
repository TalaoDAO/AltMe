import 'package:altme/app/shared/enum/type/credential_subject_type/credential_subject_type.dart';
import 'package:altme/home/credentials/models/author/author.dart';
import 'package:altme/home/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PhonePassModel extends CredentialSubjectModel {
  PhonePassModel({
    this.expires,
    this.phone,
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.phonePass,
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
