import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'over13_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Over13Model extends CredentialSubjectModel {
  Over13Model({
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.over13,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory Over13Model.fromJson(Map<String, dynamic> json) =>
      _$Over13ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Over13ModelToJson(this);
}
