import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'over15_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Over15Model extends CredentialSubjectModel {
  Over15Model({super.id, super.type, super.issuedBy, super.offeredBy})
    : super(
        credentialSubjectType: CredentialSubjectType.over15,
        credentialCategory: CredentialCategory.identityCards,
      );

  factory Over15Model.fromJson(Map<String, dynamic> json) =>
      _$Over15ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Over15ModelToJson(this);
}
