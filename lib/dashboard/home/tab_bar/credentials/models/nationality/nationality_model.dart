import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nationality_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NationalityModel extends CredentialSubjectModel {
  NationalityModel({
    this.expires,
    this.nationality,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.nationality,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory NationalityModel.fromJson(Map<String, dynamic> json) =>
      _$NationalityModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  @JsonKey(defaultValue: '')
  final String? nationality;

  @override
  Map<String, dynamic> toJson() => _$NationalityModelToJson(this);
}
