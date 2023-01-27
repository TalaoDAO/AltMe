import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'over18_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Over18Model extends CredentialSubjectModel {
  Over18Model({
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.over18,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory Over18Model.fromJson(Map<String, dynamic> json) =>
      _$Over18ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Over18ModelToJson(this);
}
