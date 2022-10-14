import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'passport_footprint_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PassportFootprintModel extends CredentialSubjectModel {
  PassportFootprintModel({
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.passportFootprint,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory PassportFootprintModel.fromJson(Map<String, dynamic> json) =>
      _$PassportFootprintModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PassportFootprintModelToJson(this);
}
