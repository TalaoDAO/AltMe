import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'age_range_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AgeRangeModel extends CredentialSubjectModel {
  AgeRangeModel({
    this.expires,
    this.ageRange,
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.ageRange,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory AgeRangeModel.fromJson(Map<String, dynamic> json) =>
      _$AgeRangeModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  @JsonKey(defaultValue: '')
  final String? ageRange;

  @override
  Map<String, dynamic> toJson() => _$AgeRangeModelToJson(this);
}
