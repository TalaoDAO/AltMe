import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'over21_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Over21Model extends CredentialSubjectModel {
  Over21Model({
    super.id,
    super.type,
    super.issuedBy,
    super.offeredBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.over21,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory Over21Model.fromJson(Map<String, dynamic> json) =>
      _$Over21ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Over21ModelToJson(this);
}
