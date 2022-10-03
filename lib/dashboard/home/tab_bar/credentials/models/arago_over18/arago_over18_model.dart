import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arago_over18_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AragoOver18Model extends CredentialSubjectModel {
  AragoOver18Model({
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.over18,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory AragoOver18Model.fromJson(Map<String, dynamic> json) =>
      _$AragoOver18ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AragoOver18ModelToJson(this);
}
