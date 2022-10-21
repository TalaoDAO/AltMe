import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arago_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AragoPassModel extends CredentialSubjectModel {
  AragoPassModel({
    String? id,
    String? type,
    Author? issuedBy,
    this.identifier,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.aragoPass,
          credentialCategory: CredentialCategory.passCards,
        );

  factory AragoPassModel.fromJson(Map<String, dynamic> json) =>
      _$AragoPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? identifier;

  @override
  Map<String, dynamic> toJson() => _$AragoPassModelToJson(this);
}
