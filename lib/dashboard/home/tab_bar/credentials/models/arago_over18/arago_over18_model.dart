import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arago_over18_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AragoOver18Model extends CredentialSubjectModel {
  AragoOver18Model({
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.aragoOver18,
          credentialCategory: CredentialCategory.passCards,
        );

  factory AragoOver18Model.fromJson(Map<String, dynamic> json) =>
      _$AragoOver18ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AragoOver18ModelToJson(this);
}
