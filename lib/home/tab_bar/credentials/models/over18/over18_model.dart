import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:json_annotation/json_annotation.dart';

part 'over18_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Over18Model extends CredentialSubjectModel {
  Over18Model({
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

  factory Over18Model.fromJson(Map<String, dynamic> json) =>
      _$Over18ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Over18ModelToJson(this);
}
